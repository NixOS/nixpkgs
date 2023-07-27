# shellcheck shell=bash
# Run addOpenGLRunpath on all dynamically linked, ELF files
echo "Sourcing auto-add-opengl-runpath-hook"

autoAddOpenGLRunpathPhase() (
  local outputPaths
  mapfile -t outputPaths < <(for o in $(getAllOutputNames); do echo "${!o}"; done)
  find "${outputPaths[@]}" -type f -executable -print0  | while IFS= read -rd "" f; do
    if isELF "$f"; then
      # patchelf returns an error on statically linked ELF files
      if patchelf --print-interpreter "$f" >/dev/null 2>&1; then
        echo "autoAddOpenGLRunpathHook: patching $f"
        addOpenGLRunpath "$f"
      elif [ -n "${DEBUG-}" ]; then
        echo "autoAddOpenGLRunpathHook: skipping ELF file $f"
      fi
    fi
  done
)

if [ -z "${dontUseAutoAddOpenGLRunpath-}" ]; then
  echo "Using autoAddOpenGLRunpathPhase"
  postFixupHooks+=(autoAddOpenGLRunpathPhase)
fi
