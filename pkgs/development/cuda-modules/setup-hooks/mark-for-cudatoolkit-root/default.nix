# Internal hook, used by cudatoolkit and cuda redist packages
# to accommodate automatic CUDAToolkit_ROOT construction
{ makeSetupHook }:
makeSetupHook {
  name = "mark-for-cudatoolkit-root";
  substitutions.logFromSetupHook = ../utilities/log-from-setup-hook.sh;
} ./mark-for-cudatoolkit-root.sh
