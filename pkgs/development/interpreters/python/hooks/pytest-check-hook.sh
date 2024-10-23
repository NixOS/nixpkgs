# Setup hook for pytest
#
# Note: For compatibility purposes,
# this setup hook Bash-evaluates the flags attributes
# before concatenating them to the command
# when __structuredAttrs is false.
#
# shellcheck shell=bash

echo "Sourcing pytest-check-hook"

# shellcheck source=pkgs/development/interpreters/python/compat-helpers.sh
source @compatHelpers@

expandStringAndConvertToArray pytestFlagsArray

function _concatSep {
    local result
    local sep="$1"
    local -n arr=$2
    for index in ${!arr[*]}; do
        # shellcheck disable=SC2086
        if [ $index -eq 0 ]; then
            result="${arr[index]}"
        else
            result+=" $sep ${arr[index]}"
        fi
    done
    echo "$result"
}

function _pytestComputeDisabledTestsString() {
    local -a tests=()
    expandStringAndConcatTo tests "$@"
    local prefix="not "
    # shellcheck disable=SC2034
    prefixed=("${tests[@]/#/$prefix}")
    result=$(_concatSep "and" prefixed)
    echo "$result"
}

function pytestCheckPhase() {
    echo "Executing pytestCheckPhase"
    runHook preCheck

    # Compose arguments
    local -a defaultFlags=()
    defaultFlags+=(-m pytest)
    if [ -n "${disabledTests[*]-}" ]; then
        local disabledTestsString
        disabledTestsString=$(_pytestComputeDisabledTestsString disabledTests)
        defaultFlags+=(-k "$disabledTestsString")
    fi

    local -a disabledTestPathsArray=()
    expandStringAndConcatTo disabledTestPathsArray disabledTestPaths

    for path in "${disabledTestPathsArray[@]}"; do
        if [ ! -e "$path" ]; then
            echo "Disabled tests path \"$path\" does not exist. Aborting"
            exit 1
        fi
        defaultFlags+=("--ignore=$path")
    done
    local -a flagsArray
    concatTo defaultFlags pytestFlagsArray
    @pythonCheckInterpreter@ "${flagsArray[@]}"

    runHook postCheck
    echo "Finished executing pytestCheckPhase"
}

if [ -z "${dontUsePytestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using pytestCheckPhase"
    appendToVar preDistPhases pytestCheckPhase
fi
