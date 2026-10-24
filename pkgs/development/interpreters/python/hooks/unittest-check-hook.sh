# Setup hook for unittest.
# shellcheck shell=bash

echo "Sourcing unittest-check-hook"

unittestCheckPhase() {
  echo "Executing unittestCheckPhase"
  runHook preCheck

  local -a flagsArray=()

  if [[ -z "${dontUseUnittestDiscover-}" ]]; then

    flagsArray+=("discover")

    if [[ -n "${enabledTests[*]-}" ]]; then
      # Process enabledTests
      local -a _patterns=()
      concatTo _patterns enabledTests
      local _pattern
      for _pattern in "${_patterns[@]}"; do
        flagsArray+=(-k"$_pattern")
      done
      unset _pattern _patterns
    elif [[ -n "${disabledTests[*]-}" ]]; then
      # Process disabledTests
      flagsArray+=("-k[!($(concatStringsSep "|" disabledTests))]")
    fi

    if [[ -n "${unittestStartDir-}" ]]; then
      flagsArray+=(--start-directory="$unittestStartDir")
    fi

    if [[ -n "${unittestFilePattern-}" ]]; then
      flagsArray+=(--pattern="$unittestFilePattern")
    fi

    if [[ -n "${unittestTopDir-}" ]]; then
      flagsArray+=(--top-level-directory="$unittestTopDir")
    fi

  else

    # Process enabledTestPaths
    if [[ -z "${enabledTestPaths[*]-}" ]]; then
      echo "ERROR: unittestCheckHook: expect non-empty enabledTestPaths when dontUseUnittestDiscover == true" >&2
      return 1
    fi
    local _enabledTestPaths_Array=() _enabledTestPaths_Expanded
    concatTo _enabledTestPaths_Array enabledTestPaths
    _enabledTestPaths_Expanded=$(
      @pythonCheckInterpreter@ - "${_enabledTestPaths_Array[@]}" <<EOF
import glob
import sys
for path_glob in sys.argv[1:]:
    if not len(path_glob):
        sys.exit("ERROR: unittestCheckHook: enabledTestPaths: got an empty element.")
    if not any(c in path_glob for c in ("*", "?", "[", "]")):
        print(path_glob)
        continue
    path_expanded = sorted(glob.glob(path_glob))
    if not len(path_expanded):
        sys.exit("ERROR: unittestCheckHook: enabledTestPaths: glob '{}' matches no paths.".format(path_glob))
    for path in path_expanded:
        print(path)
EOF
    ) || return 1
    readarray -t -O"${#flagsArray[@]}" flagsArray <<< "$_enabledTestPaths_Expanded"
    unset _enabledTestPaths_Expanded _enabledTestPaths_Array

  fi

  # Compatibility layer to the obsolete unittestFlagsArray
  eval "flagsArray+=(${unittestFlagsArray[*]-})"

  concatTo flagsArray unittestFlags

  echoCmd 'unittest flags' "${flagsArray[@]}"
  @pythonCheckInterpreter@ -m unittest "${flagsArray[@]}"

  runHook postCheck
  echo "Finished executing unittestCheckPhase"
}

if [[ -z "${dontUseUnittestCheck-}" ]] && [[ -z "${installCheckPhase-}" ]]; then
  echo "Using unittestCheckPhase"
  appendToVar preDistPhases unittestCheckPhase
fi
