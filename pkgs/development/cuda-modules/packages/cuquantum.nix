{
  backendStdenv,
  buildRedist,
  cuda_cudart,
  lib,
  libcublas,
  libcurand,
  libcusolver,
  libcusolvermp,
  libcutensor,
  nccl,
}:
buildRedist (
  finalAttrs:
  let
    inherit (backendStdenv) cudaCapabilities;
    cuquantumAtLeast = lib.versionAtLeast finalAttrs.version;
  in
  {
    redistName = "cuquantum";
    pname = "cuquantum";

    outputs = [
      "out"
      "dev"
      "include"
      "lib"
      "static"
    ];

    buildInputs = [
      cuda_cudart
      libcublas
      libcurand
      libcusolver
      libcutensor
    ];

    # libcutensornet dlopens libcusolverMp and libnccl for its (experimental) distributed tensor decompositions; the
    # libcutensorMp it also dlopens is found through libcutensor's entry in the runpath.
    # https://docs.nvidia.com/cuda/cuquantum/latest/getting-started/index.html#dependencies
    appendRunpaths =
      lib.optionals (cuquantumAtLeast "26.09" && libcusolvermp.meta.available) [
        "${lib.getLib libcusolvermp}/lib" # libcusolverMp.so.%s
      ]
      ++ lib.optionals (cuquantumAtLeast "26.09" && nccl.meta.available) [
        "${lib.getLib nccl}/lib" # libnccl.so.%s
      ];

    autoPatchelfIgnoreMissingDeps = [
      "libnvidia-ml.so.1"
    ];

    meta = {
      description = "Set of high-performance libraries and tools for accelerating quantum computing simulations at both the circuit and device level by orders of magnitude";
      longDescription = ''
        NVIDIA cuQuantum SDK is a set of high-performance libraries and tools for accelerating quantum computing
        simulations at both the circuit and device level by orders of magnitude.
      '';
      homepage = "https://developer.nvidia.com/cuquantum-sdk";
      changelog = "https://docs.nvidia.com/cuda/cuquantum/latest/cuquantum-sdk-release-notes.html";

      # https://docs.nvidia.com/cuda/cuquantum/latest/getting-started/index.html#dependencies
      problems =
        lib.optionalAttrs (!lib.all (lib.flip lib.versionAtLeast "7.5") cudaCapabilities) {
          capabilityBelow75 = {
            kind = "unsupported";
            message = "cuQuantum requires CUDA compute capabilities 7.5 and newer (found ${builtins.toJSON cudaCapabilities}).";
          };
        }
        // lib.optionalAttrs (cuquantumAtLeast "26.09" && !(lib.versionAtLeast libcutensor.version "2.8")) {
          cutensorTooOld = {
            kind = "broken";
            message =
              "cuQuantum releases since 26.09.0 (found ${finalAttrs.version})"
              + " require cuTENSOR 2.8.0 or newer (found ${libcutensor.version}).";
          };
        };
    };
  }
)
