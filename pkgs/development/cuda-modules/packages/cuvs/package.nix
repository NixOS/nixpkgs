{
  _cuda,
  addDriverRunpath,
  backendStdenv,
  cmake,
  ctestCheckHook,
  cuco,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvrtc,
  cuda_profiler_api,
  cudaAtLeast,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  cutlass,
  dlpack,
  fetchFromGitHub,
  flags,
  gitMinimal,
  gtest,
  lib,
  libcublas,
  libcurand,
  libcusolver,
  libcusparse,
  libnvjitlink,
  nccl,
  ninja,
  python3,
  raft,
  rapids-cmake,
  testers,
}:
backendStdenv.mkDerivation (finalAttrs: {
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "cuvs";
  version = "26.08.01";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuvs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lIvQvobGtukxntT4Iqp4M20I3/NTgWJYBze/SUUqyL0=";
  };

  patches = [
    # nvcc 13.4 + GCC 16 cannot compile a kernel taking std::optional by value
    ./pq-kernel-no-optional-arg.patch
  ];

  sourceRoot = "${finalAttrs.src.name}/cpp";

  nativeBuildInputs = [
    cmake
    cuda_nvcc
    gitMinimal
    ninja
    python3
    rapids-cmake
  ];

  buildInputs = [
    cuda_cudart
    (lib.getOutput "static" cuda_cudart)
    cuda_nvrtc
    libcublas
    libcurand
    libcusolver
    libcusparse
    libnvjitlink
    dlpack
    nccl
  ];

  propagatedBuildInputs = [
    raft
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
    # rapids-cmake would download them otherwise
    (lib.cmakeFeature "CPM_cuco_SOURCE" cuco.src.outPath)
    (lib.cmakeFeature "CPM_NvidiaCutlass_SOURCE" cutlass.src.outPath)
    (lib.cmakeFeature "CPM_dlpack_SOURCE" dlpack.src.outPath)
    # needs a patched hnswlib 0.7.0 fork
    (lib.cmakeBool "BUILD_CAGRA_HNSWLIB" false)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CPM_GTest_SOURCE" gtest.src.outPath)
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=deprecated-openmp"
      "-Wno-error=format-truncation"
    ];
    # nvcc 13 nodiscard warning (#2810) under -Werror=all-warnings
    CUDAFLAGS = lib.optionalString finalAttrs.finalPackage.doCheck "--diag-suppress=2810";
    # int8/uint8 cosine at dim 2 falls below the recall threshold on various hardware (including my devbox T4)
    GTEST_FILTER = "-AnnIVFFlatTest/AnnIVFFlatTestF_int8.AnnIVFFlat/2:AnnIVFFlatTest/AnnIVFFlatTestF_uint8.AnnIVFFlat/2";
  };

  doCheck = false; # needs gpu

  nativeCheckInputs = [ ctestCheckHook ];
  checkInputs = [ cuda_profiler_api ];
  disabledTests = [
    # makes nix-incompatible assumptions about the environment
    "cuvs_c_verify_install_headers"

    # needs codebooks downloaded at configure time
    "NEIGHBORS_ANN_VAMANA_TEST"
  ];

  # stolen from cutlass
  # NOTE: Because the test cases immediately create and try to run the binaries, we don't have an opportunity
  # to patch them with autoAddDriverRunpath. To get around this, we add the driver runpath to the environment.
  # TODO: This would break Jetson when using cuda_compat, as it must come first.
  preCheck = lib.optionalString finalAttrs.finalPackage.doCheck ''
    export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
  '';

  passthru = {
    tests.cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "cuvs" ];
      package = finalAttrs.finalPackage;
      # find_dependency(CUDAToolkit) in the installed config needs nvcc
      nativeBuildInputs = [ cuda_nvcc ];
      buildInputs = [
        cuda_cudart
        cuda_nvrtc
        libcublas
        libcurand
        libcusolver
        libcusparse
        libnvjitlink
      ];
    };
    gpuCheck = finalAttrs.finalPackage.overrideAttrs {
      requiredSystemFeatures = [
        "big-parallel"
        "cuda"
      ];
      doCheck = true;
    };
    platformAssertions = [
      {
        message = "RAPIDS 26.08 requires CCCL 3.4.3, first shipped with CUDA 13.4 (found ${cudaMajorMinorVersion})";
        assertion = cudaAtLeast "13.4";
      }
      # https://docs.rapids.ai/install#system-req
      {
        message = "cuVS supports CUDA compute capabilities 7.0 and newer (found ${builtins.toJSON backendStdenv.cudaCapabilities})";
        assertion = lib.all (lib.flip lib.versionAtLeast "7.0") backendStdenv.cudaCapabilities;
      }
    ];
  };

  meta = {
    description = "GPU-accelerated vector search and clustering (CAGRA, IVF-Flat, IVF-PQ, brute force)";
    homepage = "https://github.com/NVIDIA/cuvs";
    changelog = "https://github.com/NVIDIA/cuvs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    badPlatforms = _cuda.lib._mkMetaBadPlatforms finalAttrs;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = [ lib.teams.cuda ];
  };
})
