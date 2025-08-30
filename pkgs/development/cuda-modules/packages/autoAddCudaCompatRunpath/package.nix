# autoAddCudaCompatRunpath hook must be added AFTER `setupCudaHook`. Both
# hooks prepend a path with `libcuda.so` to the `DT_RUNPATH` section of
# patched elf files, but `cuda_compat` path must take precedence (otherwise,
# it doesn't have any effect) and thus appear first. Meaning this hook must be
# executed last.
{
  autoFixElfFiles,
  cuda_compat,
  makeSetupHook,
}:
makeSetupHook {
  name = "auto-add-cuda-compat-runpath-hook";
  propagatedBuildInputs = [ autoFixElfFiles ];

  substitutions = {
    libcudaPath = "${cuda_compat}/compat";
  };

  meta =
    let
      # Handle `null`s in pre-`cuda_compat` releases,
      # and `badPlatform`s for `!isJetsonBuild`.
      platforms = cuda_compat.meta.platforms or [ ];
      badPlatforms = cuda_compat.meta.badPlatforms or platforms;
    in
    {
      inherit badPlatforms platforms;
    };
} ./auto-add-cuda-compat-runpath.sh
