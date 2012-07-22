wrapPythonPrograms() {
    wrapPythonProgramsIn $out "$out $pythonPath"
}

wrapPythonProgramsIn() {
    local dir="$1"
    local pythonPath="$2"
    local python="$(type -p python)"
    local i

    declare -A pythonPathsSeen=()
    program_PYTHONPATH=
    program_PATH=
    for i in $pythonPath; do
        _addToPythonPath $i
    done

    for i in $(find "$dir" -type f -perm +0100); do

        # Rewrite "#! .../env python" to "#! /nix/store/.../python".
        if head -n1 "$i" | grep -q '#!.*/env.*python'; then
            sed -i "$i" -e "1 s^.*/env[ ]*python^#! $python^"
        fi
        
        if head -n1 "$i" | grep -q /python; then
            echo "wrapping \`$i'..."
            wrapProgram "$i" \
                --prefix PYTHONPATH ":" $program_PYTHONPATH \
                --prefix PATH ":" $program_PATH
        fi
    done
}

_addToPythonPath() {
    local dir="$1"
    if [ -n "${pythonPathsSeen[$dir]}" ]; then return; fi
    pythonPathsSeen[$dir]=1
    addToSearchPath program_PYTHONPATH $dir/lib/@libPrefix@/site-packages
    addToSearchPath program_PATH $dir/bin
    local prop="$dir/nix-support/propagated-build-native-inputs"
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
            if test -d "$x"/lib/@libPrefix@/site-packages; then
                echo $x/lib/@libPrefix@/site-packages \
                    >> "$out"/lib/@libPrefix@/site-packages/${name}-nix-python-$category.pth
            fi
        done
    fi
}
