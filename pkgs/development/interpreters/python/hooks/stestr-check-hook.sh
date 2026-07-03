# Setup hook for stestr
# shellcheck shell=bash

echo "Sourcing stestr-check-hook"

function stestrCheckPhase() {
    echo "Executing stestrCheckPhase"
    runHook preCheck

    local -a patterns=()

    # Append regex pattern
    read -ra patterns <<< "$disabledTestsRegex"

    # Sanitize disabledTests options
    if [[ -n "${disabledTests[*]-}" ]] || [[ -n "${disabledTestsRegex[*]-}" ]]; then
        # Prevent unintentional matching for specific tests
        for test in ${disabledTests[@]-}; do
            patterns+=("^${test}$")
        done
    fi

    # Compose arguments
    local -a flagsArray=()
    if [[ -n "${patterns[*]}" ]]; then
        flagsArray+=(--exclude-regex "($(concatStringsSep "|" patterns))")
    fi

    echoCmd 'stestr flags' "${flagsArray[@]}"
    @pythonCheckInterpreter@ -m stestr run "${flagsArray[@]}"

    runHook postCheck
    echo "Finished executing stestrCheckPhase"
}

if [ -z "${dontUseStestrCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using stestrCheckPhase"
    appendToVar preDistPhases stestrCheckPhase
fi
