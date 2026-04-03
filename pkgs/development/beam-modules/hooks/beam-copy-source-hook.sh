# shellcheck shell=bash
#
# When using some libraries (eg. surface or fine)
# building needs to access files in the build path of dependencies
# as returned by `module_info/1` (which requires `erlangDeterministicBuilds == false`).
# Hence this hook makes the build happen inside `$out/src` instead of /build/source`.
#
# Remark: any `patchPhase` will (correctly) be applied to `$out/src`.

beamCopySourceHook() {
  echo "Executing beamCopySourceHook"

  mkdir -p "$out"
  src="$out/src"
  cp -r "$sourceRoot" "$src"
  sourceRoot="$src"

  echo "Finished beamCopySourceHook"
}

postUnpackHooks+=(beamCopySourceHook)
