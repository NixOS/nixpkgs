{
  addDriverRunpath,
  backendStdenv,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cudaAtLeast,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  fetchFromGitHub,
  flags,
  gitUpdater,
  gtest,
  lib,
  ninja,
  rapids-cmake,
  rapids-logger,
  testers,
}:
let
  # TODO(@ethancedwards8):
  # the redist for cuda_nvtx doesnt ship the cmake config package, but github does
  # so this is why we're vendoring
  nvtxSrc = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "NVTX";
    tag = "v3.2.0";
    hash = "sha256-uB1HHLVoOO0rWOcOqfypdiveagnjDcQQZNP7xBHhCwE=";
  };
in
backendStdenv.mkDerivation (finalAttrs: {
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "rmm";
  version = "26.08.00";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rapidsai";
    repo = "rmm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NcTUF//6t/1+x2X1X4izPQpeC0BXHnulvgLMn/1ya3M=";
  };

  sourceRoot = "${finalAttrs.src.name}/cpp";

  nativeBuildInputs = [
    cmake
    ninja
    cuda_nvcc
    rapids-cmake
  ];

  buildInputs = [
    cuda_cudart
    (lib.getOutput "static" cuda_cudart)
  ];

  propagatedBuildInputs = [
    rapids-logger
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
    (lib.cmakeBool "BUILD_BENCHMARKS" false)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CPM_GTest_SOURCE" gtest.src.outPath)
    (lib.cmakeFeature "CPM_nvtx3_SOURCE" nvtxSrc.outPath)
    # The installed `*-header-search.cmake` files resolve `<prefix>/${CMAKE_INSTALL_INCLUDEDIR}`
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";

  doCheck = false; # needs gpu

  # stolen from cutlass
  # NOTE: Because the test cases immediately create and try to run the binaries, we don't have an opportunity
  # to patch them with autoAddDriverRunpath. To get around this, we add the driver runpath to the environment.
  # TODO: This would break Jetson when using cuda_compat, as it must come first.
  preCheck = lib.optionalString finalAttrs.finalPackage.doCheck ''
    export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
  '';

  passthru = {
    tests.cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "rmm" ];
      package = finalAttrs.finalPackage;
      # find_dependency(CUDAToolkit) in the installed config needs nvcc
      nativeBuildInputs = [ cuda_nvcc ];
      buildInputs = [ cuda_cudart ];
    };
    gpuCheck = finalAttrs.finalPackage.overrideAttrs {
      requiredSystemFeatures = [
        "big-parallel"
        "cuda"
      ];
      doCheck = true;
    };
  };

  meta = {
    description = "RAPIDS Memory Manager";
    homepage = "https://github.com/rapidsai/rmm";
    changelog = "https://github.com/rapidsai/rmm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    problems = lib.optionalAttrs (!(cudaAtLeast "13.4")) {
      cudaTooOld = {
        kind = "unsupported";
        message = "RAPIDS 26.08 requires CCCL 3.4.3, first shipped with CUDA 13.4 (found ${cudaMajorMinorVersion}).";
      };
    };
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = [ lib.teams.cuda ];
  };
})
