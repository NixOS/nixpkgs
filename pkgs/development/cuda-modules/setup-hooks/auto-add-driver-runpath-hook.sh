# shellcheck shell=bash
# Run addDriverRunpath on all dynamically linked, ELF files
echo "Sourcing auto-add-driver-runpath-hook"

elfHasDynamicSection() {
    patchelf --print-rpath "$1" >& /dev/null
}

autoAddDriverRunpathPhase() (
  local outputPaths
  mapfile -t outputPaths < <(for o in $(getAllOutputNames); do echo "${!o}"; done)
  find "${outputPaths[@]}" -type f -executable -print0  | while IFS= read -rd "" f; do
    if isELF "$f"; then
      # patchelf returns an error on statically linked ELF files
      if elfHasDynamicSection "$f" ; then
        echo "autoAddDriverRunpathHook: patching $f"
        addDriverRunpath "$f"
      elif (( "${NIX_DEBUG:-0}" >= 1 )) ; then
        echo "autoAddDriverRunpathHook: skipping a statically-linked ELF file $f"
      fi
    fi
  done
)

if [ -z "${dontUseAutoAddDriverRunpath-}" ]; then
  echo "Using autoAddDriverRunpathPhase"
  postFixupHooks+=(autoAddDriverRunpathPhase)
fi
