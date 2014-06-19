addPythonPath() {
    addToSearchPathWithCustomDelimiter : PYTHONPATH $1/lib/pypy2.3/site-packages
}

toPythonPath() {
    local paths="$1"
    local result=
    for i in $paths; do
        p="$i/lib/pypy2.3/site-packages"
        result="${result}${result:+:}$p"
    done
    echo $result
}

envHooks=(${envHooks[@]} addPythonPath)
