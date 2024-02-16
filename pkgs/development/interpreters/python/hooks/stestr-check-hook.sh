# Setup hook for stestr.
echo "Sourcing stestr-check-hook"

declare -ar disabledTests

function _stestrComputeDisabledTestsString() {
    regex=""
    for test in "$@"; do
        if [ -n "$regex" ]; then
            regex+="|"
        fi
        regex+="^($( echo "$test" | sed -s 's/\./\\\./'))"
    done
    echo "$regex"
}


function stestrCheckPhase() {
    echo "Executing stestrCheckPhase"
    runHook preCheck

    args=" -m stestr run"
    if [ -n "$disabledTests" ]; then
        args+=" -E '$(_stestrComputeDisabledTestsString $disabledTests)'"
     fi

    eval "@pythonCheckInterpreter@ $args"

    runHook postCheck
    echo "Finished executing stestrCheckPhase"
}

if [ -z "${dontUseStestrCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using stestrCheckPhase"
    preDistPhases+=" stestrCheckPhase"

    # It's almost always the case that setuptoolsCheckPhase should not be ran
    # when the stestrCheckHook is being ran
    if [ -z "${useSetuptoolsCheck-}" ]; then
        dontUseSetuptoolsCheck=1

        # Remove command if already injected into preDistPhases
        if [[ "$preDistPhases" =~ "setuptoolsCheckPhase" ]]; then
            echo "Removing setuptoolsCheckPhase"
            preDistPhases=${preDistPhases/setuptoolsCheckPhase/}
        fi
    fi
fi
