# Setup hook for unittest.
echo "Sourcing unittest-check-hook"

unittestCheckPhase() {
    echo "Executing unittestCheckPhase"
    runHook preCheck

    if [ -n "$__structuredAttrs" ]; then
        @pythonCheckInterpreter@ -m unittest discover "${unittestFlagsArray[@]}"
    else
        eval "@pythonCheckInterpreter@ -m unittest discover $unittestFlagsArray"
    fi

    runHook postCheck
    echo "Finished executing unittestCheckPhase"
}

if [ -z "${dontUseUnittestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using unittestCheckPhase"
    preDistPhases+=" unittestCheckPhase"

    # It's almost always the case that setuptoolsCheckPhase should not be ran
    # when the unittestCheckHook is being ran
    if [ -z "${useSetuptoolsCheck-}" ]; then
        dontUseSetuptoolsCheck=1

        # Remove command if already injected into preDistPhases
        if [[ "$preDistPhases" =~ "setuptoolsCheckPhase" ]]; then
            echo "Removing setuptoolsCheckPhase"
            preDistPhases=${preDistPhases/setuptoolsCheckPhase/}
        fi
    fi
fi
