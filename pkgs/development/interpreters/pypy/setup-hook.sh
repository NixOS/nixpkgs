addPythonPath() {
    addToSearchPathWithCustomDelimiter : PYTHONPATH $1/site-packages
}

toPythonPath() {
    local paths="$1"
    local result=
    for i in $paths; do
        p="$i/site-packages"
        result="${result}${result:+:}$p"
    done
    echo $result
}

envHooks+=(addPythonPath)
