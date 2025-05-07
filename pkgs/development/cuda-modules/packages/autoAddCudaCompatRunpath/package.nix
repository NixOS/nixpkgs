# autoAddCudaCompatRunpath hook must be added AFTER `setupCudaHook`. Both
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

  substitutions = {
    # Hotfix Ofborg evaluation
    libcudaPath = if flags.isJetsonBuild then "${cuda_compat}/compat" else null;
  };

  meta.broken = !flags.isJetsonBuild;

  # Pre-cuda_compat CUDA release:
  meta.badPlatforms = lib.optionals (cuda_compat == null) lib.platforms.all;
  meta.platforms = cuda_compat.meta.platforms or [ ];
} ./auto-add-cuda-compat-runpath.sh
