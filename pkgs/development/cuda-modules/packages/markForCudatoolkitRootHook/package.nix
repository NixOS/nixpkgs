# Internal hook, used by cudatoolkit and cuda redist packages
# to accommodate automatic CUDAToolkit_ROOT construction
{ makeSetupHook }:
makeSetupHook { name = "mark-for-cudatoolkit-root-hook"; } ./mark-for-cudatoolkit-root-hook.sh
