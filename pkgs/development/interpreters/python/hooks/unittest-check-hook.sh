# Setup hook for unittest.
echo "Sourcing unittest-check-hook"

unittestCheckPhase() {
    echo "Executing unittestCheckPhase"
    runHook preCheck

    # Old bash empty array hack
    # shellcheck disable=SC2086
    local flagsArray=(
        ${unittestFlags:-} "${unittestFlagsArray[@]}"
    )
    echoCmd 'unittest check flags' "${flagsArray[@]}"
    @pythonCheckInterpreter@ -m unittest discover "${flagsArray[@]}"

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
