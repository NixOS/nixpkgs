# shellcheck shell=bash

# Only run the hook from nativeBuildInputs when strictDeps is set
if [[ -n ${removeStubsFromRunpathHookOnce-} ]]; then
  # shellcheck disable=SC2154
  nixDebugLog "skipping sourcing removeStubsFromRunpathHook.bash (hostOffset=$hostOffset) (targetOffset=$targetOffset)" \
    "because it has already been sourced"
  return 0
fi

declare -g removeStubsFromRunpathHookOnce=1

nixLog "sourcing removeStubsFromRunpathHook.bash (hostOffset=$hostOffset) (targetOffset=$targetOffset)"

# NOTE: Adding to prePhases to ensure all setup hooks are sourced prior to adding our hook.
appendToVar prePhases removeStubsFromRunpathHookRegistration
nixLog "added removeStubsFromRunpathHookRegistration to prePhases"

# Registering during prePhases ensures that all setup hooks are sourced prior to installing ours,
# allowing us to always go after autoAddDriverRunpath and autoPatchelfHook.
removeStubsFromRunpathHookRegistration() {
  local postFixupHook

  for postFixupHook in "${postFixupHooks[@]}"; do
    if [[ $postFixupHook == "autoFixElfFiles addDriverRunpath" ]]; then
      nixLog "discovered 'autoFixElfFiles addDriverRunpath' in postFixupHooks; this hook should be unnecessary when" \
        "linking against stub files!"
    fi
  done

  postFixupHooks+=("autoFixElfFiles removeStubsFromRunpath")
  nixLog "added removeStubsFromRunpath to postFixupHooks"

  return 0
}

removeStubsFromRunpath() {
  local libPath
  local runpathEntry
  local -a origRunpathEntries=()
  local -a newRunpathEntries=()
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

  # NOTE: Always pre-increment since (( 0 )) sets an exit code of 1.
  for runpathEntry in "${origRunpathEntries[@]}"; do
    case $runpathEntry in
    # NOTE: This assumes stubs have "-cuda" (`cudaNamePrefix` in `buildRedist`) in name.
    # Match on (sub)directories named stubs or lib inside a stubs output.
    *-cuda*/stubs|*-cuda*-stubs/lib*)
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

  local -r newRunpath=$(concatStringsSep ":" newRunpathEntries)
  patchelf --set-rpath "$newRunpath" "$libPath"
}
