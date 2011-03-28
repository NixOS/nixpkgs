wrapPythonPrograms() {
    wrapPythonProgramsIn $out "$out $pythonPath"
}

wrapPythonProgramsIn() {
    local dir="$1"
    local pythonPath="$2"
    local i

    declare -A pythonPathsSeen=()
    program_PYTHONPATH=
    program_PATH=
    for i in $pythonPath; do
        _addToPythonPath $i
    done

    for i in $(find "$dir" -type f -perm +0100); do
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
    addToSearchPath program_PYTHONPATH $dir/lib/python2.7/site-packages
    addToSearchPath program_PATH $dir/bin
    local prop="$dir/nix-support/propagated-build-native-inputs"
    if [ -e $prop ]; then
        local i
        for i in $(cat $prop); do
            _addToPythonPath $i
        done
    fi
}
