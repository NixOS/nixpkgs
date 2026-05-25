# Internal hook, used by cudatoolkit and cuda redist packages
# to accommodate automatic CUDAToolkit_ROOT construction
{
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "mark-for-cudatoolkit-root-hook";
  meta.license = lib.licenses.mit;
} ./mark-for-cudatoolkit-root-hook.sh
