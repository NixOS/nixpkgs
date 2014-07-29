wrapPythonPrograms() {
    wrapPythonProgramsIn $out "$out $pythonPath"
}

wrapPythonProgramsIn() {
    local dir="$1"
    local pythonPath="$2"
    local python="@executable@"
    local i

    declare -A pythonPathsSeen=()
    program_PYTHONPATH=
    program_PATH=
    for i in $pythonPath; do
        _addToPythonPath $i
    done

    for i in $(find "$dir" -type f -perm +0100); do

        # Rewrite "#! .../env python" to "#! /nix/store/.../python".
        if head -n1 "$i" | grep -q '#!.*/env.*\(python\|pypy\)'; then
            sed -i "$i" -e "1 s^.*/env[ ]*\(python\|pypy\)^#! $python^"
        fi
        
        if head -n1 "$i" | grep -q '/python\|/pypy'; then
            # dont wrap EGG-INFO scripts since they are called from python
            if echo "$i" | grep -v EGG-INFO/scripts; then
                echo "wrapping \`$i'..."
                sed -i "$i" -re '1 {
                    /^#!/!b; :r
                    /\\$/{N;b r}
                    /__future__|^ *(#.*)?$/{n;b r}
                    /^ *[^# ]/i import sys; sys.argv[0] = '"'$(basename "$i")'"'
                }'
                wrapProgram "$i" \
                    --prefix PYTHONPATH ":" $program_PYTHONPATH \
                    --prefix PATH ":" $program_PATH
            fi
        fi
    done
}

_addToPythonPath() {
    local dir="$1"
    if [ -n "${pythonPathsSeen[$dir]}" ]; then return; fi
    pythonPathsSeen[$dir]=1
    addToSearchPath program_PYTHONPATH $dir/lib/@libPrefix@/site-packages
    addToSearchPath program_PATH $dir/bin
    local prop="$dir/nix-support/propagated-native-build-inputs"
    if [ -e $prop ]; then
        local i
        for i in $(cat $prop); do
            _addToPythonPath $i
        done
    fi
}

createBuildInputsPth() {
    local category="$1"
    local inputs="$2"
    if [ foo"$inputs" != foo ]; then
        for x in $inputs; do
            if $(echo -n $x |grep -q python-recursive-pth-loader); then
                continue
            fi
            if test -d "$x"/lib/@libPrefix@/site-packages; then
                echo $x/lib/@libPrefix@/site-packages \
                    >> "$out"/lib/@libPrefix@/site-packages/${name}-nix-python-$category.pth
            fi
        done
    fi
}
