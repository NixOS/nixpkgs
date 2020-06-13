# Helper functions for deepin packaging

searchHardCodedPaths() {
    # Usage:
    #
    #   searchHardCodedPaths [-a] [<path>]
    #
    # Looks for ocurrences of FHS hard coded paths and command
    # invocations in the given path (default: current directory) for
    # the purpose of debugging a derivation. The option -a enables
    # processing binary files as if they were text.

    local binary
    if [ "$1" = "-a" ]; then
        binary="-a"
        shift
    fi

    local path=$1

    local display_path=$path
    if [ -z "$display_path" ]; then
        display_path=$(pwd)
    fi

    echo ---------- looking for hard coded paths and command invocations in $display_path

    grep \
        --color=always \
        $binary \
        -r \
        -E '(/usr|/bin|/sbin|/etc|/var|/opt|(\<(ExecStart|Exec|startDetached|execute|exec\.(Command|LookPath))))\>' \
        $path \
     | sort \
     || true

    echo ---------- done
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
