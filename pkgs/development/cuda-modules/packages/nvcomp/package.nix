{
  addDriverRunpath,
  backendStdenv,
  buildRedist,
  cuda_cudart,
  cuda_nvcc,
  lib,
}:
buildRedist (finalAttrs: {
  redistName = "nvcomp";
  pname = "nvcomp";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  # https://docs.nvidia.com/cuda/nvcomp/installation.html
  platformAssertions = [
    {
      message =
        "nvCOMP supports CUDA compute capabilities 7.0 and newer"
        + " (found ${builtins.toJSON backendStdenv.cudaCapabilities})";
      assertion = lib.all (lib.flip lib.versionAtLeast "7.0") backendStdenv.cudaCapabilities;
    }
  ];

  # Compresses and decompresses a batch with the LZ4 C API on the GPU and checks the result.
  passthru.gpuCheck = backendStdenv.mkDerivation {
    __structuredAttrs = true;
    strictDeps = true;

    name = "${finalAttrs.finalPackage.name}-gpu-check";

    src = ./roundtrip.cu;
    dontUnpack = true;

    nativeBuildInputs = [ cuda_nvcc ];

    buildInputs = [
      cuda_cudart
      finalAttrs.finalPackage
    ];

    buildPhase = ''
      runHook preBuild
      nvcc -o roundtrip "$src" -lnvcomp
      runHook postBuild
    '';

    doCheck = true;
    checkPhase = ''
      runHook preCheck
      export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
      ./roundtrip
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      touch "$out"
      runHook postInstall
    '';

    requiredSystemFeatures = [ "cuda" ];

    meta = {
      inherit (finalAttrs.finalPackage.meta) badPlatforms platforms teams;
    };
  };

  meta = {
    description = "High-speed data compression and decompression library optimized for NVIDIA GPUs";
    longDescription = ''
      NVIDIA nvCOMP is a high-speed data compression and decompression library optimized for NVIDIA GPUs.
    '';
    homepage = "https://developer.nvidia.com/nvcomp";
    changelog = "https://docs.nvidia.com/cuda/nvcomp/release_notes.html";
  };
})
