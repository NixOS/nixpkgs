# Setup hook for pytest
# shellcheck shell=bash

echo "Sourcing pytest-check-hook"

function _pytestIncludeExcludeExpr() {
    local includeListName="$1"
    local -n includeListRef="$includeListName"
    local excludeListName="$2"
    local -n excludeListRef="$excludeListName"
    local includeString excludeString
    if [[ -n "${includeListRef[*]-}" ]]; then
        # ((element1) or (element2))
        includeString="(($(concatStringsSep ") or (" "$includeListName")))"
    fi
    if [[ -n "${excludeListRef[*]-}" ]]; then
        # and not (element1) and not (element2)
        excludeString="${includeString:+ and }not ($(concatStringsSep ") and not (" "$excludeListName"))"
    fi
    echo "$includeString$excludeString"
}

function pytestCheckPhase() {
    echo "Executing pytestCheckPhase"
    runHook preCheck

    # Compose arguments
    local -a flagsArray=(-m pytest)

    local -a _pathsArray
    local path

    _pathsArray=()
    concatTo _pathsArray enabledTestPaths
    for path in "${_pathsArray[@]}"; do
        if [[ "$path" =~ "::" ]]; then
            flagsArray+=("$path")
        else
            # The `|| kill "$$"` trick propagates the errors from the process substitutiton subshell,
            # which is suggested by a StackOverflow answer: https://unix.stackexchange.com/a/217643
            readarray -t -O"${#flagsArray[@]}" flagsArray < <(
                @pythonCheckInterpreter@ - "$path" <<EOF || kill "$$"
import glob
import sys
path_glob=sys.argv[1]
if not len(path_glob):
    sys.exit('Got an empty enabled tests path glob. Aborting')
path_expanded = glob.glob(path_glob)
if not len(path_expanded):
    sys.exit('Enabled tests path glob "{}" does not match any paths. Aborting'.format(path_glob))
for path in path_expanded:
    print(path)
EOF
            )
        fi
    done

    _pathsArray=()
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

    if [[ -n "${enabledTests[*]-}" ]] || [[ -n "${disabledTests[*]-}" ]]; then
        flagsArray+=(-k "$(_pytestIncludeExcludeExpr enabledTests disabledTests)")
    fi

    if [[ -n "${enabledTestMarks[*]-}" ]] || [[ -n "${disabledTestMarks[*]-}" ]]; then
        flagsArray+=(-m "$(_pytestIncludeExcludeExpr enabledTestMarks disabledTestMarks)")
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
