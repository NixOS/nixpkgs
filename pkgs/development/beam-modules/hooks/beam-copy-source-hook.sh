# shellcheck shell=bash
#
# Copy the source so it can be used by mix projects to assemble `deps`
# do this before building to avoid build artifacts but after patching
# to include any user modifications to the source

beamCopySourceHook() {
  echo "Executing beamCopySourceHook"

  mkdir -p "$out/src"
  cp -r "." "$out/src"

  echo "Finished beamCopySourceHook"
}

postPatchHooks+=(beamCopySourceHook)
