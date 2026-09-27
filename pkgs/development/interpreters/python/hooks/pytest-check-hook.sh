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
    local -a flagsArray=()

    local _pytestFlags_asArray=()
    concatTo _pytestFlags_asArray pytestFlags

    local -a overrideIniFlags=()
    local _flag
    for _flag in $_pytest_config_addopts; do
        if [[ "$_flag" =~ ^(-o|--override-ini[=\ ])(.*)$ ]]; then
            overrideIniFlags+=("$_flag")
        fi
    done

    # For backward compatibility to existing `--import-mode` flag in `pytestFlags`
    if [[ -z "${pytestImportMode-}" ]]; then
        local _flag
        for _flag in "${_pytestFlags_asArray[@]}"; do
            if [[ "$_flag" =~ ^--import-mode[=\ ](.+)$ ]]; then
                pytestImportMode="${BASH_REMATCH[1]}"
            fi
        done
        if [[ -n "${pytestImportMode-}" ]]; then
            echo "pytestCheckHook: --import-mode flag has been added with pytestFlags" >&2
            dontAddPytestImportMode=1
        fi
    fi

    # In case pytest configuration addopts set --import-mode, observe its value.
    if [[ -z "${pytestImportMode-}" ]]; then
        local _flag _pytest_config_addopts
        _pytest_config_addopts="$(
            echo "pytestCheckHook: getting pytestconfig.addopts value by running pytest" >&2
            pytest \
              -p no:cacheprovider "${overrideIniFlags[@]}" \
              @pytestCheckHookResources@/test_pytest_get_value.py::test_pytestconfig_getoption_addopts \
              3>&1 1>/dev/null
            echo "pytestCheckHook: finished getting pytestconfig.addopts value by running pytest" >&2
        )"
        if [[ -n "$_pytest_config_addopts" ]]; then
            for _flag in $_pytest_config_addopts; do
                if [[ "$_flag" =~ ^--import-mode[=\ ](.*)$ ]]; then
                    pytestImportMode="${BASH_REMATCH[1]}"
                fi
            done
        fi
        if [[ -n "${pytestImportMode-}" ]]; then
            echo "--import-mode flag has been added with pytest configuration addopts" >&2
            dontAddPytestImportMode=1
        fi
    fi

    # Default pytestImportMode to "importlib", contrary to pytest's default behaviour "prepend".
    # pytestImportMode = "importlib" makes pytest import the test modules without modifying `sys.path`,
    # allowing installed modules (instead of the unbuilt modules in CWD) to be used by the test modules.
    : "${pytestImportMode:=importlib}"

    echo "pytestCheckHook: pytestImprotMode is $pytestImportMode" >&2

    if [[ -z "${dontAddPytestImportMode-}" ]]; then
        flagsArray+=(--import-mode="$pytestImportMode")
    fi

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
                @pythonCheckInterpreter@ @pytestCheckHookResources@/expand-glob.py "$path" "1" "Enabled test path glob" || kill "$$")
        fi
    done

    _pathsArray=()
    concatTo _pathsArray disabledTestPaths
    for path in "${_pathsArray[@]}"; do
        if [[ "$path" =~ "::" ]]; then
            flagsArray+=("--deselect=$path")
        else
            # Check if every path glob matches at least one path
            @pythonCheckInterpreter@ @pytestCheckHookResources@/expand-glob.py "$path" "" "Disabled test path glob"
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
    pytest "${flagsArray[@]}"

    runHook postCheck
    echo "Finished executing pytestCheckPhase"
}

if [ -z "${dontUsePytestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using pytestCheckPhase"
    appendToVar preDistPhases pytestCheckPhase
fi
