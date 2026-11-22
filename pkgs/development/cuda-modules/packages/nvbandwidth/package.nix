{
  lib,
  backendStdenv,
  fetchFromGitHub,
  fetchpatch,
  flags,

  # nativeBuildInputs
  cmake,
  cuda_nvcc,

  # buildInputs
  argparse,
  cuda_cudart,
  cuda_nvml_dev,

  # passthru
  nvbandwidth,

  config,
  cudaSupport ? config.cudaSupport,
}:
backendStdenv.mkDerivation (finalAttrs: {
  pname = "nvbandwidth";
  version = "0.11.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvbandwidth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XB6uzSBTiXLdietsjFkxrwco6kmFmMnGc921noE002I=";
  };

  patches = [
    # Force a dynamic Boost build and link against the CUDA driver / NVML stubs via the CMake
    # imported targets exposed by `find_package(CUDAToolkit)`.
    ./use-cuda-imported-targets.patch

    # Fix link failure when the last CUDA arch is < sm_100 (e.g. [ "10.0" "8.9" ])
    # https://github.com/NVIDIA/nvbandwidth/pull/74
    (fetchpatch {
      name = "fix-multi-arch-kernel-stubs.patch";
      url = "https://github.com/NVIDIA/nvbandwidth/commit/3a32d2c84d419bde4b4e7485ae62953ed09bf63e.patch";
      hash = "sha256-5RYNnCv31hMn+Er/LNJJlh30kWpmu2O/knYMluLA1vM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cuda_nvcc
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
  ];

  buildInputs = [
    argparse
    cuda_cudart # cuda_runtime.h, libcuda stub
    cuda_nvml_dev # libnvidia-ml
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 nvbandwidth -t $out/bin

    runHook postInstall
  '';

  passthru.gpuCheck = nvbandwidth.overrideAttrs (_: {
    requiredSystemFeatures = [ "cuda" ];
    doInstallCheck = true;
    postInstallCheck = ''
      $out/bin/${nvbandwidth.meta.mainProgram}
    '';

    # Failing (probably a sandbox limitation):
    #   hwloc/linux: failed to find sysfs cpu topology directory, aborting linux discovery.
    meta.broken = true;
  });

  meta = {
    description = "Tool for bandwidth measurements on NVIDIA GPUs";
    homepage = "https://github.com/NVIDIA/nvbandwidth";
    changelog = "https://github.com/NVIDIA/nvbandwidth/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "nvbandwidth";
    platforms = lib.platforms.linux;
    broken = !cudaSupport;
  };
})
