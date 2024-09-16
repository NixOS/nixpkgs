# Internal hook, used by cudatoolkit and cuda redist packages
# to accommodate automatic CUDAToolkit_ROOT construction
{ cudaMajorMinorVersion, makeSetupHook }:
makeSetupHook {
  name = "cuda${cudaMajorMinorVersion}-mark-for-cudatoolkit-root-hook";
} ./mark-for-cudatoolkit-root-hook.sh
