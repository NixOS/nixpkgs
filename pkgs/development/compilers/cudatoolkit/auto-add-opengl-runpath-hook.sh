# shellcheck shell=bash
# Run addOpenGLRunpath on all dynamically linked, ELF files
echo "Sourcing auto-add-opengl-runpath-hook"

elfHasDynamicSection() {
    patchelf --print-rpath "$1" >& /dev/null
}

autoAddOpenGLRunpathPhase() (
  local outputPaths
  mapfile -t outputPaths < <(for o in $(getAllOutputNames); do echo "${!o}"; done)
  find "${outputPaths[@]}" -type f -executable -print0  | while IFS= read -rd "" f; do
    if isELF "$f"; then
      # patchelf returns an error on statically linked ELF files
      if elfHasDynamicSection "$f" ; then
        echo "autoAddOpenGLRunpathHook: patching $f"
        addOpenGLRunpath "$f"
      elif (( "${NIX_DEBUG:-0}" >= 1 )) ; then
        echo "autoAddOpenGLRunpathHook: skipping a statically-linked ELF file $f"
      fi
    fi
  done
)

if [ -z "${dontUseAutoAddOpenGLRunpath-}" ]; then
  echo "Using autoAddOpenGLRunpathPhase"
  postFixupHooks+=(autoAddOpenGLRunpathPhase)
fi
