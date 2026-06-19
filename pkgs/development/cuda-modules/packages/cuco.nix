{
  addDriverRunpath,
  backendStdenv,
  catch2_3,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cudaAtLeast,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  fetchFromGitHub,
  flags,
  lib,
  ninja,
  rapids-cmake,
  unstableGitUpdater,
}:
backendStdenv.mkDerivation (finalAttrs: {
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "cuco";
  version = "0-unstable-2026-07-02"; # no tags :(

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuCollections";
    rev = "0883368d39296f3bef3a058033141bcc642c5c54";
    hash = "sha256-fK7jpF4V5djX/drGabq8YePVm0AevM8W0jvPFtXXKZQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    cuda_nvcc
    rapids-cmake
  ];

  buildInputs = [
    cuda_cudart
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "\''${CMAKE_CURRENT_BINARY_DIR}/CUCO_RAPIDS.cmake" \
        "${rapids-cmake}/share/rapids-cmake/RAPIDS.cmake"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
    (lib.cmakeBool "INSTALL_CUCO" true)
    (lib.cmakeBool "BUILD_BENCHMARKS" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CPM_Catch2_SOURCE" catch2_3.src.outPath)
    (lib.cmakeBool "CUCO_DOWNLOAD_ROARING_TESTDATA" false)
  ];

  doCheck = false; # needs gpu

  # stolen from cutlass
  # NOTE: Because the test cases immediately create and try to run the binaries, we don't have an opportunity
  # to patch them with autoAddDriverRunpath. To get around this, we add the driver runpath to the environment.
  # TODO: This would break Jetson when using cuda_compat, as it must come first.
  preCheck = lib.optionalString finalAttrs.finalPackage.doCheck ''
    export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
  '';

  passthru = {
    gpuCheck = finalAttrs.finalPackage.overrideAttrs {
      requiredSystemFeatures = [
        "big-parallel"
        "cuda"
      ];
      doCheck = true;
      enableParallelChecking = false; # 500+ tests
    };

    updateScript = unstableGitUpdater { branch = "dev"; };
  };

  meta = {
    description = "Header-only library of GPU-accelerated, concurrent data structures";
    homepage = "https://github.com/NVIDIA/cuCollections";
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    problems =
      lib.optionalAttrs (!(cudaAtLeast "13.4")) {
        cudaTooOld = {
          kind = "unsupported";
          message = "cuCollections requires CCCL 3.4.3, first shipped with CUDA 13.4 (found ${cudaMajorMinorVersion}).";
        };
      }
      # https://github.com/NVIDIA/cuCollections#requirements
      // lib.optionalAttrs (!lib.all (lib.flip lib.versionAtLeast "7.0") backendStdenv.cudaCapabilities) {
        capabilityBelow70 = {
          kind = "unsupported";
          message = "cuCollections requires CUDA compute capabilities 7.0 and newer (found ${builtins.toJSON backendStdenv.cudaCapabilities}).";
        };
      };
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = [ lib.teams.cuda ];
  };
})
