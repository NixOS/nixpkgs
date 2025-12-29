# shellcheck shell=bash
beamCopySourceHook() {
  echo "Executing beamCopySourceHook"

  # Copy the source so it can be used by mix projects
  # do this before building to avoid build artifacts but after patching
  # to include any modifications
  mkdir -p "$out/src"
  cp -r "." "$out/src"

  echo "Finished beamCopySourceHook"
}

postPatchHooks+=(beamCopySourceHook)
