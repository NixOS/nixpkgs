# Setup hook for checking whether Python imports succeed
echo "Sourcing python-imports-check-hook.sh"

pythonImportsCheckPhase () {
    echo "Executing pythonImportsCheckPhase"

    local importCheckPyCode='import sys, importlib; [importlib.import_module(mod) for mod in sys.argv[1:]]'

    if [ -n "$pythonImportsCheck" ]; then
        echo "Check whether the following modules can be imported: $pythonImportsCheck"
        # FIXME: should this be removed? See #201277
        export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

        # enumerate all output store paths
        local output
        local _outputs=""
        for output in $(getAllOutputNames); do
            _outputs="$_outputs ${!output}"
        done

        (
            buildPythonPath "$_outputs"
            ( # FIXME: remove this debugging helper before merge
                set +e
                echo "pythonImportsCheckPhase PATH and PYTHONPATH diff:"
                diff --unified --color=always \
                    <(echo "$PATH"               | sed -e 's/:/\n/g' | sort --unique) \
                    <(echo "$program_PATH"       | sed -e 's/:/\n/g' | sort --unique) | tail -n+4
                diff --unified --color=always \
                    <(echo "$PYTHONPATH"         | sed -e 's/:/\n/g' | sort --unique) \
                    <(echo "$program_PYTHONPATH" | sed -e 's/:/\n/g' | sort --unique) | tail -n+4
                true
            )
            cd $out
            env --ignore-environment PATH="$program_PATH" PYTHONPATH="$program_PYTHONPATH" @pythonCheckInterpreter@ -c "$importCheckPyCode" $pythonImportsCheck
        )
    fi

    if [ -n "$pythonImportsExtrasCheck" ]; then
        echo "Check whether the following extra modules can be imported: $pythonImportsExtrasCheck"
        # FIXME: should this be removed? See #201277
        export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"
        (
            cd $out
            @pythonCheckInterpreter@ -c "$importCheckPyCode" $pythonImportsExtrasCheck
        )
    fi
}

if [ -z "${dontUsePythonImportsCheck-}" ]; then
    echo "Using pythonImportsCheckPhase"
    preDistPhases+=" pythonImportsCheckPhase"
fi
