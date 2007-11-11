addPythonPath() {
	addToSearchPathWithCustomDelimiter : PYTHONPATH /lib/python2.4/site-packages "" $1
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
