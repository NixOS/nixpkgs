# Setup hook for pytest
echo "Sourcing pytest-check-hook"

declare -ar disabledTests

function _concatSep {
    local result
    local sep="$1"
    local -n arr=$2
    for index in ${!arr[*]}; do
        if [ $index -eq 0 ]; then
            result="${arr[index]}"
        else
            result+=" $sep ${arr[index]}"
        fi
    done
    echo "$result"
}

function _pytestComputeDisabledTestsString () {
    declare -a tests
    local tests=($1)
    local prefix="not "
    prefixed=( "${tests[@]/#/$prefix}" )
    result=$(_concatSep "and" prefixed)
    echo "$result"
}

function pytestCheckPhase() {
    echo "Executing pytestCheckPhase"
    runHook preCheck

    # Compose arguments
    args=" -m pytest"
    if [ -n "$disabledTests" ]; then
        disabledTestsString=$(_pytestComputeDisabledTestsString "${disabledTests[@]}")
      args+=" -k \""$disabledTestsString"\""
    fi
    args+=" ${pytestFlagsArray[@]}"
    eval "@pythonCheckInterpreter@ $args"

    runHook postCheck
    echo "Finished executing pytestCheckPhase"
}

if [ -z "$dontUsePytestCheck" ] && [ -z "$installCheckPhase" ]; then
    echo "Using pytestCheckPhase"
    preDistPhases+=" pytestCheckPhase"
fi
