# Setup hook for pytest
echo "Sourcing pytest-check-hook"

function _concatSep {
    local result
    local sep="$1"
    shift
    local arr=("$@")
    for index in ${!arr[*]}; do
        if [ "$index" -eq 0 ]; then
            result="${arr[index]}"
        else
            result+=" $sep ${arr[index]}"
        fi
    done
    echo "$result"
}

function _pytestComputeDisabledTestsString () {
    declare -a tests=("${@}")
    local prefix="not "
    prefixed=( "${tests[@]/#/$prefix}" )
    result=$(_concatSep "and" "${prefixed[@]}")
    echo "$result"
}

if [ -n "$__structuredAttrs" ]; then
    function pytestCheckPhase() {
        echo "Executing pytestCheckPhase"
        runHook preCheck

        # Compose arguments
        args=("-m" "pytest")
        if [ -n "${disabledTests[*]}" ]; then
          disabledTestsString=$(_pytestComputeDisabledTestsString "${disabledTests[@]}")
          args+=("-k" "${disabledTestsString}")
        fi

        for path in "${disabledTestPaths[@]}"; do
          if [ ! -e "$path" ]; then
            echo "Disabled tests path \"$path\" does not exist. Aborting"
            exit 1
          fi
          args+=("--ignore=$path")
        done
        args+=("${pytestFlagsArray[@]}")
        @pythonCheckInterpreter@ "${args[@]}"

        runHook postCheck
        echo "Finished executing pytestCheckPhase"
    }
else
    declare -ar disabledTests
    declare -a disabledTestPaths

    function pytestCheckPhase() {
        echo "Executing pytestCheckPhase"
        runHook preCheck

        # Compose arguments
        local args=" -m pytest"
        if [ -n "$disabledTests" ]; then
            disabledTestsString=$(_pytestComputeDisabledTestsString ${disabledTests[*]})
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
        args+=" ${pytestFlagsArray[*]}"
        eval "@pythonCheckInterpreter@ $args"

        runHook postCheck
        echo "Finished executing pytestCheckPhase"
    }
fi

if [ -z "${dontUsePytestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using pytestCheckPhase"
    preDistPhases+=" pytestCheckPhase"

    # It's almost always the case that setuptoolsCheckPhase should not be ran
    # when the pytestCheckHook is being ran
    if [ -z "${useSetuptoolsCheck-}" ]; then
        dontUseSetuptoolsCheck=1

        # Remove command if already injected into preDistPhases
        if [[ "$preDistPhases" =~ "setuptoolsCheckPhase" ]]; then
            echo "Removing setuptoolsCheckPhase"
            preDistPhases=${preDistPhases/setuptoolsCheckPhase/}
        fi
    fi
fi
