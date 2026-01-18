# autoAddCudaCompatRunpath hook must be added AFTER `setupCudaHook`. Both
# hooks prepend a path with `libcuda.so` to the `DT_RUNPATH` section of
# patched elf files, but `cuda_compat` path must take precedence (otherwise,
# it doesn't have any effect) and thus appear first. Meaning this hook must be
# executed last.
{
  autoFixElfFiles,
  cuda_compat,
  lib,
  makeSetupHook,
}:
let
  # cuda_compat can be null or broken, depending on the platform, CUDA release, and compute capability.
  # To avoid requiring all consumers of this hook to do these checks, we do them here; the hook is a no-op if
  # cuda_compat is not available.
  enableHook = cuda_compat.meta.available or false;
in
makeSetupHook {
  name = "auto-add-cuda-compat-runpath-hook";
  propagatedBuildInputs = lib.optionals enableHook [ autoFixElfFiles ];

  substitutions = {
    libcudaPath = lib.optionalString enableHook "${cuda_compat}/compat";
  };

  passthru = {
    inherit enableHook;
  };
} ./auto-add-cuda-compat-runpath.sh
