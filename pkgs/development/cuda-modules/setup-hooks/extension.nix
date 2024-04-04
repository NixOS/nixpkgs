final: _: {
  # Helper hook used in both autoAddCudaCompatRunpath and
  # autoAddDriverRunpath that applies a generic patching action to all elf
  # files with a dynamic linking section.
  autoFixElfFiles = final.callPackage (
    { makeSetupHook }: makeSetupHook { name = "auto-fix-elf-files"; } ./auto-fix-elf-files.sh
  ) { };

  # Internal hook, used by cudatoolkit and cuda redist packages
  # to accommodate automatic CUDAToolkit_ROOT construction
  markForCudatoolkitRootHook = final.callPackage (
    { makeSetupHook }:
    makeSetupHook { name = "mark-for-cudatoolkit-root-hook"; } ./mark-for-cudatoolkit-root-hook.sh
  ) { };

  # Currently propagated by cuda_nvcc or cudatoolkit, rather than used directly
  setupCudaHook = (
    final.callPackage (
      { makeSetupHook, backendStdenv }:
      makeSetupHook {
        name = "setup-cuda-hook";

        substitutions.setupCudaHook = placeholder "out";

        # Point NVCC at a compatible compiler
        substitutions.ccRoot = "${backendStdenv.cc}";

        # Required in addition to ccRoot as otherwise bin/gcc is looked up
        # when building CMakeCUDACompilerId.cu
        substitutions.ccFullPath = "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++";
      } ./setup-cuda-hook.sh
    ) { }
  );

  autoAddDriverRunpath = final.callPackage (
    {
      addDriverRunpath,
      autoFixElfFiles,
      makeSetupHook,
    }:
    makeSetupHook {
      name = "auto-add-opengl-runpath-hook";
      propagatedBuildInputs = [
        addDriverRunpath
        autoFixElfFiles
      ];
    } ./auto-add-driver-runpath-hook.sh
  ) { };

  # Deprecated: an alias kept for compatibility. Consider removing after 24.11
  autoAddOpenGLRunpathHook = final.autoAddDriverRunpath;

  # autoAddCudaCompatRunpath hook must be added AFTER `setupCudaHook`. Both
  # hooks prepend a path with `libcuda.so` to the `DT_RUNPATH` section of
  # patched elf files, but `cuda_compat` path must take precedence (otherwise,
  # it doesn't have any effect) and thus appear first. Meaning this hook must be
  # executed last.
  autoAddCudaCompatRunpath = final.callPackage (
    {
      makeSetupHook,
      autoFixElfFiles,
      cuda_compat ? null,
    }:
    makeSetupHook {
      name = "auto-add-cuda-compat-runpath-hook";
      propagatedBuildInputs = [ autoFixElfFiles ];

      substitutions = {
        # Hotfix Ofborg evaluation
        libcudaPath = if final.flags.isJetsonBuild then "${cuda_compat}/compat" else null;
      };

      meta.broken = !final.flags.isJetsonBuild;

      # Pre-cuda_compat CUDA release:
      meta.badPlatforms = final.lib.optionals (cuda_compat == null) final.lib.platforms.all;
      meta.platforms = cuda_compat.meta.platforms or [ ];
    } ./auto-add-cuda-compat-runpath.sh
  ) { };
}
