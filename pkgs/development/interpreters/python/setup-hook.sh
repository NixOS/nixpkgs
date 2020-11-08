addPythonPath() {
    addToSearchPathWithCustomDelimiter : PYTHONPATH $1/@sitePackages@
    # Include the dependencies in `required-python-modules` as well
    local prop="$1/nix-support/required-python-modules"
    if [ -e $prop ]; then
        local new_path
        for new_path in $(cat $prop); do
            addToSearchPathWithCustomDelimiter : PYTHONPATH $new_path/@sitePackages@
        done
    fi
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

if [ -z "${dontAddPythonPath:-}" ]; then
    addEnvHooks "$hostOffset" addPythonPath
fi

# Determinism: The interpreter is patched to write null timestamps when compiling python files.
# This way python doesn't try to update them when we freeze timestamps in nix store.
export DETERMINISTIC_BUILD=1;
# Determinism: We fix the hashes of str, bytes and datetime objects.
export PYTHONHASHSEED=0;
# Determinism. Whenever Python is included, it should not check user site-packages.
# This option is only relevant when the sandbox is disabled.
export PYTHONNOUSERSITE=1;
