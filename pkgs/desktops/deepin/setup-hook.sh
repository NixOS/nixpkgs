# Helper functions for deepin packaging

searchHardCodedPaths() {
    # looks for ocurrences of hard coded paths in given (current)
    # directory and command invocations for the purpose of debugging a
    # derivation

    local dir=$1

    echo ----------- looking for command invocations
    grep --color=always -r -E '\<(ExecStart|Exec|startDetached|execute|exec\.(Command|LookPath))\>' $dir || true

    echo ----------- looking for hard coded paths
    grep --color=always -a -r -E '/(usr|bin|sbin|etc|var|opt)\>' $dir || true

    echo ----------- done
}

fixPath() {
    # Usage:
    #
    #   fixPath <parent dir> <path> <files>
    #
    # replaces occurences of <path> by <parent_dir><path> in <files>
    # removing /usr from the start of <path> if present

    local parentdir=$1
    local path=$2
    local newpath=$parentdir$(echo $path | sed "s,^/usr,,")
    local files=("${@:3}")
    echo ======= grep --color=always "${path}" "${files[@]}"
    grep --color=always "${path}" "${files[@]}"
    echo +++++++ sed -i -e "s,$path,$newpath,g" "${files[@]}"
    sed -i -e "s,$path,$newpath,g" "${files[@]}"
}

searchForUnresolvedDLL() {
    # Usage:
    #
    #   searchForUnresolvedDLL <dir>
    #
    # looks in <dir> for executables with unresolved dynamic library paths

    local dir="$1"
    echo ======= Looking for executables with unresolved dynamic library dependencies
    echo $dir
    for f in $(find -L "$dir" -type f -executable); do
      if (ldd $f | grep -q "not found"); then
        echo $f
        ldd $f | grep --color=always "not found"
      fi
    done
}
