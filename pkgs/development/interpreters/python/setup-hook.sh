addPythonPath() {
    addToSearchPathWithCustomDelimiter : PYTHONPATH $1/@sitePackages@
}

toPythonPath() {
    local paths="$1"
    local result=
    for i in $paths; do
        p="$i/@sitePackages@"
        result="${result}${result:+:}$p"
    done
    echo $result
}

envHooks+=(addPythonPath)

# Determinism: The interpreter is patched to write null timestamps when compiling python files.
# This way python doesn't try to update them when we freeze timestamps in nix store.
export DETERMINISTIC_BUILD=1;
# Determinism: We fix the hashes of str, bytes and datetime objects.
export PYTHONHASHSEED=0;
