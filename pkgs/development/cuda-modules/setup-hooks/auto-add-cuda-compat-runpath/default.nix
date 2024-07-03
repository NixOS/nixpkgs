# autoAddCudaCompatRunpath hook must be added AFTER `setupCuda`. Both
# hooks prepend a path with `libcuda.so` to the `DT_RUNPATH` section of
# patched elf files, but `cuda_compat` path must take precedence (otherwise,
# it doesn't have any effect) and thus appear first. Meaning this hook must be
# executed last.
{
  autoFixElfFiles,
  cuda_compat ? null,
  flags,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "auto-add-cuda-compat-runpath-hook";
  propagatedBuildInputs = [ autoFixElfFiles ];
  substitutions.libcudaPath = lib.optionalString flags.isJetsonBuild "${cuda_compat}/compat";
  meta = {
    broken = !flags.isJetsonBuild;
    badPlatforms = lib.optionals (cuda_compat == null) lib.platforms.all;
    platforms = cuda_compat.meta.platforms or [ ];
  };
} ./auto-add-cuda-compat-runpath.sh
