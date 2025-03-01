# Setup hook for pytest
# shellcheck shell=bash

echo "Sourcing pytest-check-hook"

function pytestCheckPhase() {
    echo "Executing pytestCheckPhase"
    runHook preCheck

    # Compose arguments
    local -a flagsArray=(-m pytest)

    local -a _pathsArray=()
    concatTo _pathsArray disabledTestPaths
    for path in "${_pathsArray[@]}"; do
        if [[ "$path" =~ "::" ]]; then
            flagsArray+=("--deselect=$path")
        else
            # Check if every path glob matches at least one path
            @pythonCheckInterpreter@ - "$path" <<EOF
import glob
import sys
path_glob=sys.argv[1]
if not len(path_glob):
    sys.exit('Got an empty disabled tests path glob. Aborting')
if next(glob.iglob(path_glob), None) is None:
    sys.exit('Disabled tests path glob "{}" does not match any paths. Aborting'.format(path_glob))
EOF
            flagsArray+=("--ignore-glob=$path")
        fi
    done

    if [ -n "${disabledTests[*]-}" ]; then
        disabledTestsString="not $(concatStringsSep " and not " disabledTests)"
        flagsArray+=(-k "$disabledTestsString")
    fi

    # Compatibility layer to the obsolete pytestFlagsArray
    eval "flagsArray+=(${pytestFlagsArray[*]-})"

    concatTo flagsArray pytestFlags
    echoCmd 'pytest flags' "${flagsArray[@]}"
    @pythonCheckInterpreter@ "${flagsArray[@]}"

    runHook postCheck
    echo "Finished executing pytestCheckPhase"
}

if [ -z "${dontUsePytestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using pytestCheckPhase"
    appendToVar preDistPhases pytestCheckPhase
fi
