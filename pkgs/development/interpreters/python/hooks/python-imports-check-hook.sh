# shellcheck shell=bash

# Setup hook for checking whether Python imports succeed
echo "Sourcing python-imports-check-hook.sh"

pythonImportsCheckPhase() {
    echo "Executing pythonImportsCheckPhase"

    if [[ -n "${pythonImportsCheck[*]-}" ]]; then
        echo "Check whether the following modules can be imported: ${pythonImportsCheck[*]}"
        # shellcheck disable=SC2154
        pythonImportsCheckOutput="$out"
        if [[ -n "${python-}" ]]; then
            echo "Using python specific output \$python for imports check"
            pythonImportsCheckOutput=$python
        fi
        export PYTHONPATH="$pythonImportsCheckOutput/@pythonSitePackages@:$PYTHONPATH"
        # Python modules and namespaces names are Python identifiers, which must not contain spaces.
        # See https://docs.python.org/3/reference/lexical_analysis.html
        # shellcheck disable=SC2048,SC2086
        (cd "$pythonImportsCheckOutput" && @pythonCheckInterpreter@ -c 'import sys; import importlib; list(map(lambda mod: importlib.import_module(mod), sys.argv[1:]))' ${pythonImportsCheck[*]})
    fi
}

if [[ -z "${dontUsePythonImportsCheck-}" ]]; then
    echo "Using pythonImportsCheckPhase"
    appendToVar preDistPhases pythonImportsCheckPhase
fi
