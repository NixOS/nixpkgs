# Setup hook for PyPA installer.
echo "Sourcing python-runtime-deps-check-hook"

pythonRuntimeDepsCheckHook() {
    echo "Executing pythonRuntimeDepsCheck"

    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    for wheel in dist/*.whl; do
        echo "Checking runtime dependencies for $(basename $wheel)"
        @pythonInterpreter@ @hook@ "$wheel"
    done

    echo "Finished executing pythonRuntimeDepsCheck"
}

if [ -z "${dontCheckRuntimeDeps-}" ]; then
    echo "Using pythonRuntimeDepsCheckHook"
    appendToVar preInstallPhases pythonRuntimeDepsCheckHook
fi
