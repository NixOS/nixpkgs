# Setup hook for pytest
echo "Sourcing pytest-check-hook"

declare -ar disabledTests
declare -a disabledTestPaths

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

function pytestBinaryPatchPhase() {
    # This patch of code is necessary because `python -m pytest` is known to
    # create circular import errors in libraries that have native extensions
    # such as libraries with Cython modules
    #
    # The problem of calling pytest directly is that not necessarily the pytest
    # command will use the @pythonCheckInterpreter@ python so we copy, patch
    # and add the pytest binary before all others using PATH prepend
    echo "Executing pytestBinaryPatchPhase"
    local actualEntrypoint=$(which pytest)
    local pytestBinaryDirectory=$(mktemp -d)

    PATH="$pytestBinaryDirectory:$PATH"

    if (( "${NIX_DEBUG:-0}" >= 1 )); then
        echo "pytestBinaryPatchPhase: actualEntrypoint: $actualEntrypoint"
        echo "pytestBinaryPatchPhase: originalPythonInterpreterBin: $originalPythonInterpreterBin"
        echo "pytestBinaryPatchPhase: pytestBinaryDirectory: $pytestBinaryDirectory"
        echo "pytestBinaryPatchPhase: patched PATH: $PATH"
        echo "pytestBinaryPatchPhase: which pytest: $(which pytest)"
    fi
    install -m 755 "$(dirname $actualEntrypoint)"/* $pytestBinaryDirectory
    substituteInPlace "$pytestBinaryDirectory"/* \
        --replace "@pytestPython@" "$(dirname "$(dirname "@pythonCheckInterpreter@")")"
}

function pytestCheckPhase() {
    echo "Executing pytestCheckPhase"
    runHook preCheck

    # Compose arguments
    args=""
    if [ -n "$disabledTests" ]; then
        disabledTestsString=$(_pytestComputeDisabledTestsString "${disabledTests[@]}")
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
    eval "pytest $args"

    runHook postCheck
    echo "Finished executing pytestCheckPhase"
}

if [ -z "${dontUsePytestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using pytestCheckPhase"
    preDistPhases+=" pytestBinaryPatchPhase pytestCheckPhase"

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
