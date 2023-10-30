# Setup hook for checking whether Python imports succeed
echo "Sourcing python-imports-check-hook.sh"

pythonImportsCheckPhase () {
    echo "Executing pythonImportsCheckPhase"

    if [ -n "$pythonImportsCheck" ]; then
        echo "Check whether the following modules can be imported: $pythonImportsCheck"
        # TODO(globin) use .attrs.json?
        export pythonImportsCheckStr="${pythonImportsCheck[*]}"
        export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"
        ( cd $out && eval "@pythonCheckInterpreter@ -c 'import os; import importlib; list(map(lambda mod: importlib.import_module(mod), os.environ[\"pythonImportsCheckStr\"].split()))'" )
    fi
}

if [ -z "${dontUsePythonImportsCheck-}" ]; then
    echo "Using pythonImportsCheckPhase"
    preDistPhases+=" pythonImportsCheckPhase"
fi
