# Setup hook for pytest
# shellcheck shell=bash

echo "Sourcing pytest-check-hook"

function pytestCheckPhase() {
    echo "Executing pytestCheckPhase"
    runHook preCheck

    # Compose arguments
    local -a flagsArray=(-m pytest)
    if [ -n "${disabledTests[*]-}" ]; then
        disabledTestsString="not $(concatStringsSep " and not " disabledTests)"
        flagsArray+=(-k "$disabledTestsString")
    fi

    local -a _pathsArray=()
    concatTo _pathsArray disabledTestPaths
    for path in "${_pathsArray[@]}"; do
        # Check if every path glob matches at least one path
        @pythonCheckInterpreter@ <(cat <<EOF
import glob
import sys
path_glob=sys.argv[1]
if not len(path_glob):
    sys.exit('Got an empty disabled tests path glob. Aborting')
if next(glob.iglob(path_glob), None) is None:
    sys.exit('Disabled tests path glob "{}" does not match any paths. Aborting'.format(path_glob))
EOF
        ) "$path"
        flagsArray+=("--ignore-glob=$path")
    done

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
