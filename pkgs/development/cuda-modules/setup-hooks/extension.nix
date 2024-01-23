let
  createSetupHooks =
    setupHooksAttrs: final: prev:
    let
      # It is imperative that we use `final.callPackage` to create these setup hooks, as it allows us access to the spliced
      # package sets.
      inherit (final) callPackage;

      # NOTE(@connorbaker): We MUST use `lib` from `prev` because the attribute names CAN NOT depend on `final`.
      inherit (prev.lib.attrsets) mapAttrs;

      aliases = {
        # Deprecated: an alias kept for compatibility. Consider removing after 24.11
        autoAddOpenGLRunpathHook = final.autoAddDriverRunpath;
      };
    in
    mapAttrs (_: value: callPackage value { }) setupHooksAttrs // aliases;
in
createSetupHooks {
  # Helper hook used in both autoAddCudaCompatRunpath and
  # autoAddDriverRunpath that applies a generic patching action to all elf
  # files with a dynamic linking section.
  autoFixElfFiles =
    { makeSetupHook }: makeSetupHook { name = "auto-fix-elf-files"; } ./auto-fix-elf-files.sh;

  # Internal hook, used by cudatoolkit and cuda redist packages
  # to accommodate automatic CUDAToolkit_ROOT construction
  markForCudatoolkitRootHook =
    { makeSetupHook }:
    makeSetupHook { name = "mark-for-cudatoolkit-root-hook"; } ./mark-for-cudatoolkit-root-hook.sh;

  # Currently propagated by cuda_nvcc or cudatoolkit, rather than used directly
  setupCudaHook =
    { backendStdenv, makeSetupHook }:
    makeSetupHook
      {
        name = "setup-cuda-hook";

        substitutions = {
          # Required in addition to ccRoot as otherwise bin/gcc is looked up
          # when building CMakeCUDACompilerId.cu
          ccFullPath = "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++";
          # Point NVCC at a compatible compiler
          ccRoot = "${backendStdenv.cc}";
          setupCudaHook = placeholder "out";
        };
      }
      ./setup-cuda-hook.sh;

  autoAddDriverRunpath =
    {
      addDriverRunpath,
      autoFixElfFiles,
      makeSetupHook,
    }:
    makeSetupHook
      {
        name = "auto-add-opengl-runpath-hook";
        propagatedBuildInputs = [
          addDriverRunpath
          autoFixElfFiles
        ];
      }
      ./auto-add-driver-runpath-hook.sh;

  # autoAddCudaCompatRunpath hook must be added AFTER `setupCudaHook`. Both
  # hooks prepend a path with `libcuda.so` to the `DT_RUNPATH` section of
  # patched elf files, but `cuda_compat` path must take precedence (otherwise,
  # it doesn't have any effect) and thus appear first. Meaning this hook must be
  # executed last.
  autoAddCudaCompatRunpath =
    {
      autoFixElfFiles,
      cuda_compat ? null,
      flags,
      lib,
      makeSetupHook,
    }:
    makeSetupHook
      {
        name = "auto-add-cuda-compat-runpath-hook";
        propagatedBuildInputs = [ autoFixElfFiles ];

        substitutions.libcudaPath = lib.optionalString flags.isJetsonBuild "${cuda_compat}/compat";

        meta = {
          broken = !flags.isJetsonBuild;
          badPlatforms = lib.optionals (cuda_compat == null) lib.platforms.all;
          platforms = cuda_compat.meta.platforms or [ ];
        };
      }
      ./auto-add-cuda-compat-runpath.sh;
}
