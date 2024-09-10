# Setup hook for checking whether Python imports succeed
echo "Sourcing python-imports-check-hook.sh"

pythonImportsCheckPhase() {
    echo "Executing pythonImportsCheckPhase"

    if [ -n "${pythonImportsCheck[*]-}" ]; then
        echo "Check whether the following modules can be imported: ${pythonImportsCheck[*]}"
        # shellcheck disable=SC2154
        pythonImportsCheckOutput="$out"
        if [ -n "${python-}" ]; then
            echo "Using python specific output \$python for imports check"
            pythonImportsCheckOutput=$python
        fi
        export PYTHONPATH="$pythonImportsCheckOutput/@pythonSitePackages@:$PYTHONPATH"
        (cd "$pythonImportsCheckOutput" && @pythonCheckInterpreter@ -c 'import sys; import importlib; list(map(lambda mod: importlib.import_module(mod), sys.argv[1:]))' ${pythonImportsCheck[*]})
    fi
}

if [ -z "${dontUsePythonImportsCheck-}" ]; then
    echo "Using pythonImportsCheckPhase"
    appendToVar preDistPhases pythonImportsCheckPhase
fi
