# Setup hook for unittest.
# shellcheck shell=bash

echo "Sourcing unittest-check-hook"

unittestCheckPhase() {
    echo "Executing unittestCheckPhase"
    runHook preCheck

    local -a flagsArray=()

    if [[ -n "${unittestStartDir-}" ]]; then
        flagsArray+=(--start-directory="$unittestStartDir")
    fi

    if [[ -n "${unittestFilePattern-}" ]]; then
        flagsArray+=(--pattern="$unittestFilePattern")
    fi

    if [[ -n "${unittestTopDir-}" ]]; then
        flagsArray+=(--top-level-directory="$unittestTopDir")
    fi

    if [[ -n "${enabledTests[*]-}" ]]; then
        local -a _patterns=()
        concatTo _patterns enabledTests
        local _pattern
        for _pattern in "${_patterns[@]}"; do
            flagsArray+=(-k"$_pattern")
        done
        unset _pattern _patterns
    fi

    # Compatibility layer to the obsolete unittestFlagsArray
    eval "flagsArray+=(${unittestFlagsArray[*]-})"

    concatTo flagsArray unittestFlags
    echoCmd 'unittest flags' "${flagsArray[@]}"
    @pythonCheckInterpreter@ -m unittest discover "${flagsArray[@]}"

    runHook postCheck
    echo "Finished executing unittestCheckPhase"
}

if [[ -z "${dontUseUnittestCheck-}" ]] && [[ -z "${installCheckPhase-}" ]]; then
    echo "Using unittestCheckPhase"
    appendToVar preDistPhases unittestCheckPhase
fi
