{
  autoAddDriverRunpath,
  addDriverRunpath,
  backendStdenv,
  cudaOlder,
  cuda_cccl,
  cuda_cudart,
  cuda_cupti,
  cuda_nvcc,
  cuda_nvml_dev,
  cudaMajorMinorVersion,
  fetchFromGitHub,
  lib,
  rapids-cmake,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.strings)
    cmakeBool
    concatStringsSep
    cmakeFeature
    optionalString
    ;

  # TODO: These tests complain about missing libraries which are available when requiredSystemFeatures includes "cuda"
  ignoredTests = [
    "nvbench.test.cmake.test_export.build_tree"
    "nvbench.test.cmake.test_export.install_tree"
  ];

in
backendStdenv.mkDerivation (finalAttrs: {
  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nvbench";
  version = "0-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvbench";
    rev = "a171514056e5d6a7f52a035dd6c812fa301d4f4f";
    hash = "sha256-S8IVvJPUrPVmilw6ftqr+oia5uoVALmteBWORiASDBg=";
  };

  strictDeps = true;

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    cuda_nvcc
    rapids-cmake
  ];

  postPatch =
    # Copy required components and update permissions
    rapids-cmake.passthru.utilities.copyToCmakeDir
    # Patch NVBench to use our vendored rapids-cmake
    + ''
      echo "Patching cmake/NVBenchRapidsCMake.cmake to use our vendored rapids-cmake"
      substituteInPlace cmake/NVBenchRapidsCMake.cmake \
        --replace-fail \
          'if(NOT EXISTS "''${CMAKE_CURRENT_BINARY_DIR}/NVBENCH_RAPIDS.cmake")' \
          "if(FALSE)" \
        --replace-fail \
          'include("''${CMAKE_CURRENT_BINARY_DIR}/NVBENCH_RAPIDS.cmake")' \
          'add_subdirectory("''${CMAKE_CURRENT_SOURCE_DIR}/cmake/rapids-cmake")'
    ''
    # Correct the assumptions about CUPTI's location.
    # NOTE: `dev` and `include` are different outputs; `include` contains the actual headers, while `dev` uses
    #       nix-support/* files to manage adding dependencies.
    + ''
      echo "Patching cmake/NVBenchCUPTI.cmake to fix paths"
      substituteInPlace cmake/NVBenchCUPTI.cmake \
        --replace-fail \
          '"''${nvbench_cupti_root}/include"' \
          '"${cuda_cupti.include}/include"'
    '';

  enableParallelBuilding = true;

  buildInputs = [
    cuda_cccl
    cuda_cudart
    cuda_cupti
    cuda_nvml_dev
  ];

  # TODO: This should be handled by setup hooks in rapids-cmake.
  cmakeFlags = rapids-cmake.passthru.data.cmakeFlags ++ [
    (cmakeBool "NVBench_ENABLE_TESTING" finalAttrs.doCheckGpu)
    # NOTE: NVBench_ENABLE_HEADER_TESTING can be done independently of GPU availability.
    (cmakeBool "NVBench_ENABLE_HEADER_TESTING" finalAttrs.doCheck)
    # NOTE: We do not use NVBench_ENABLE_DEVICE_TESTING because it requires a GPU with locked clocks.
    (cmakeBool "NVBench_ENABLE_DEVICE_TESTING" false)

    # Pass arguments to the ctest executable when run through the CMake test target.
    # Nixpkgs uses `make test` so this is necessary unless we want a custom checkPhase.
    # For more on the options available to ctest, see:
    # https://cmake.org/cmake/help/book/mastering-cmake/chapter/Testing%20With%20CMake%20and%20CTest.html#testing-using-ctest
    (cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      concatStringsSep ";" [
        # Run only tests with the CUDA label
        "-L"
        "CUDA"
        # Exclude ignored tests
        "-E"
        "'${concatStringsSep "|" ignoredTests}'"
      ]
    ))
  ];

  doCheck = true;
  doCheckGpu = false;

  requiredSystemFeatures = optionals finalAttrs.doCheckGpu [ "cuda" ];

  # NOTE: Because the test cases immediately create and try to run the binaries, we don't have an opportunity
  # to patch them with autoAddDriverRunpath. To get around this, we add the driver runpath to the environment.
  preCheck = optionalString finalAttrs.doCheckGpu ''
    export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
  '';

  passthru = {
    updateScript = gitUpdater {
      inherit (finalAttrs) pname version;
      rev-prefix = "v";
    };
    tests.withGpu = finalAttrs.finalPackage.overrideAttrs { doCheckGpu = true; };
  };

  meta = with lib; {
    description = "CUDA Kernel Benchmarking Library";
    homepage = "https://github.com/NVIDIA/nvbench";
    license = licenses.asl20;
    broken = cudaOlder "11.4" || !(finalAttrs.doCheckGpu -> finalAttrs.doCheck);
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ connorbaker ] ++ teams.cuda.members;
  };
})
