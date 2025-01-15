# Setup hook for pytest
echo "Sourcing pytest-check-hook"

declare -ar disabledTests
declare -a disabledTestPaths

function pytestCheckPhase() {
    echo "Executing pytestCheckPhase"
    runHook preCheck

    # Compose arguments
    args=" -m pytest"
    if [ -n "$disabledTests" ]; then
        disabledTestsString="not $(concatStringsSep " and not " disabledTests)"
        args+=" -k \""$disabledTestsString"\""
    fi

    if [ -n "${disabledTestPaths-}" ]; then
        eval "disabledTestPaths=($disabledTestPaths)"
    fi

    for path in ${disabledTestPaths[@]}; do
        if [ ! -e "$path" ]; then
            echo "Disabled tests path \"$path\" does not exist. Aborting"
            exit 1
        fi
        args+=" --ignore=\"$path\""
    done
    args+=" ${pytestFlagsArray[@]}"
    eval "@pythonCheckInterpreter@ $args"

    runHook postCheck
    echo "Finished executing pytestCheckPhase"
}

if [ -z "${dontUsePytestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using pytestCheckPhase"
    appendToVar preDistPhases pytestCheckPhase
fi
