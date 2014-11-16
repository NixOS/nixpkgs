addPythonPath() {
    addToSearchPathWithCustomDelimiter : PYTHONPATH $1/lib/python3.4/site-packages
}

toPythonPath() {
    local paths="$1"
    local result=
    for i in $paths; do
        p="$i/lib/python3.4/site-packages"
        result="${result}${result:+:}$p"
    done
    echo $result
}

envHooks+=(addPythonPath)
