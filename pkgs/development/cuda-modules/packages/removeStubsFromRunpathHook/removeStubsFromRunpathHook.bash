# shellcheck shell=bash

# Only run the hook from depsBuildBuild when strictDeps is set
if [[ -n ${removeStubsFromRunpathHookOnce-} ]]; then
  nixDebugLog "skipping sourcing removeStubsFromRunpathHook.bash (hostOffset=${hostOffset:-0}) (targetOffset=${targetOffset:-0})" \
    " because it has already been sourced"
  return 0
elif [[ -n ${strictDeps:-} ]] && ((${hostOffset:-0} != -1 || ${targetOffset:-0} != -1)); then
  nixDebugLog "skipping sourcing removeStubsFromRunpathHook.bash (hostOffset=${hostOffset:-0}) (targetOffset=${targetOffset:-0})" \
    " because it is not in depsBuildBuild"
  return 0
fi

declare -g removeStubsFromRunpathHookOnce=1

nixLog "sourcing removeStubsFromRunpathHook.bash (hostOffset=${hostOffset:-0}) (targetOffset=${targetOffset:-0})"

removeStubsFromRunpath() {
  local libPath
  local runpathEntry
  local -a origRunpathEntries=()
  local -a newRunpathEntries=()
  local newRunpath
  local -r driverLinkLib="@driverLinkLib@"
  local -i driverLinkLibSightings=0

  if [[ $# -eq 0 ]]; then
    nixErrorLog "no library path provided" >&2
    exit 1
  elif [[ $# -gt 1 ]]; then
    nixErrorLog "too many arguments" >&2
    exit 1
  elif [[ $1 == "" ]]; then
    nixErrorLog "empty library path" >&2
    exit 1
  else
    libPath="$1"
  fi

  getRunpathEntries "$libPath" origRunpathEntries

  # TODO(@connorbaker): Order of runpath entries matters.
  # NOTE: Always increment with a pre-increment when the value starts at zero. With a post-increment, the original value
  # is used in the arithmetic expression, so if the value starts at zero, zero is the result of the arithmetic expression,
  # which results in a return code of 1 indicating an error. This is a nightmare to debug with set -e.
  for runpathEntry in "${origRunpathEntries[@]}"; do
    case $runpathEntry in
    # NOTE: This assumes all CUDA redistributables with stubs use cudaNamePrefix in name;
    # that should be safe given the redistributables are built with buildRedist, which does
    # this automatically.
    *-cuda*/lib/stubs)
      if ((driverLinkLibSightings)); then
        # No need to add another copy of the driverLinkLib; just drop the stubs entry.
        nixDebugLog "dropping $libPath runpath entry: $runpathEntry"
      else
        # We haven't observed a driverLinkLib yet, so replace the stubs entry with one.
        nixDebugLog "replacing $libPath runpath entry: $runpathEntry -> $driverLinkLib"
        newRunpathEntries+=("$driverLinkLib")
        ((++driverLinkLibSightings))
      fi
      ;;

    *)
      nixDebugLog "keeping $libPath runpath entry: $runpathEntry"
      newRunpathEntries+=("$runpathEntry")
      [[ $runpathEntry == "$driverLinkLib" ]] && ((++driverLinkLibSightings))
      ;;
    esac
  done

  newRunpath=$(concatStringsSep ":" newRunpathEntries)

  nixDebugLog "replacing $libPath runpath with $newRunpath"

  patchelf --set-rpath "$newRunpath" "$libPath"

  return 0
}

postFixupHooks+=("autoFixElfFiles removeStubsFromRunpath")
