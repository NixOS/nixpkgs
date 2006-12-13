addPythonPath() {
    local p=$1/lib/python2.4/site-packages
    if test -d $p; then
        export PYTHONPATH="${PYTHONPATH}${PYTHONPATH:+:}$p"
    fi
}

toPythonPath() {
    local paths="$1"
    local result=
    for i in $paths; do
        p="$i/lib/python2.4/site-packages"
        result="${result}${result:+:}$p"
    done
    echo $result
}

envHooks=(${envHooks[@]} addPythonPath)
