XKO=${XKO:-$(dirname ${BASH_SOURCE[0]})}

source $HOME/.bush/rc

# <<< just load all *.rc from everywhere, organize them any way we like, 
# <<< no need for .profile and complex symlinking - we do git branches now
function x.startlist {
    find -L $XKO/.profile -name "*.sh" -print 2>/dev/null | xargs readlink -f | uniq | rev | sort | rev
    find -L $XKO/.transient -name "*.sh" -print 2>/dev/null | xargs readlink -f 2>/dev/null | uniq | rev | sort | rev
}

function x.askY {
    local prompt="${1:-"Continue?"}"
    read -p "$prompt " -n 1 -r
    [[ $REPLY =~ ^[Yy]$ ]]
} 

function x.showerr { 
    local r=$?
    local before="$1"
    local after="$2"
    [[ $r == 0 ]] && printf "$before\e[1;32m$r\e[1;0m$after"  
    [[ $r != 0 ]] && printf "$before\e[1;31m$r\e[1;0m$after"
}

echo "-> $XKO"
_all_start=$(date +%s.%N)
for _f in $( x.startlist ); do
    # _start=$(date +%s.%n)
    printf "%-60s" "-> $_f"
    source $_f
    x.showerr " " "\n"
    # _end=$(date +%s.%N)
    # awk "BEGIN {printf (\"<- %.4f\n\", $_end - $_start)}"
done
_all_end=$(date +%s.%N)
echo -n "<- "
awk "BEGIN {print $_all_end - $_all_start}"
