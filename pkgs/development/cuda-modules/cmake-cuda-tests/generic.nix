{
  autoAddDriverRunpath,
  backendStdenv,
  cmake,
  cudaOlder,
  cuda_nvcc ? null,
  cuda_cudart ? null,
  cudatoolkit ? null,
  cudatoolkit-legacy-runfile ? null,
  cudaMajorMinorVersion,
  lib,
  testGroup,
  testName,
  testCudaPackageType,
  testConfig,
  writeShellApplication,
}:
let
  inherit (lib.asserts) assertMsg;
  inherit (lib.attrsets) attrValues getBin;
  inherit (lib.lists) any elem;
  inherit (lib.strings) optionalString;
  inherit (lib.trivial) id;

  # NOTE: This block allows us to decide on the base packages for each testCudaPackageType. Individual tests
  # can have additional dependencies, but these are common to all tests.
  # NOTE: Using an if expression to make clear that these options are mutually exclusive, which optionals does not
  # convey.
  inherit
    (
      if (testCudaPackageType == "redist") then
        {
          baseNativeBuildInputs = [ cuda_nvcc ];
          baseBuildInputs = [ cuda_cudart ];
        }
      else if (testCudaPackageType == "cudatoolkit") then
        {
          baseNativeBuildInputs = [ cudatoolkit ];
          baseBuildInputs = [ cudatoolkit ];
        }
      else if (testCudaPackageType == "cudatoolkit-legacy-runfile") then
        {
          baseNativeBuildInputs = [ cudatoolkit-legacy-runfile ];
          baseBuildInputs = [ cudatoolkit-legacy-runfile ];
        }
      else
        builtins.throw "Unknown testCudaPackageType: ${testCudaPackageType}"
    )
    baseNativeBuildInputs
    baseBuildInputs
    ;
in
assert assertMsg (elem testCudaPackageType [
  "redist"
  "cudatoolkit"
  "cudatoolkit-legacy-runfile"
]) "testCudaPackageType must be one of 'redist', 'cudatoolkit', or 'cudatoolkit-legacy-runfile'";
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "cmake-test-${testCudaPackageType}-${testGroup}.${testName}";
  inherit (cmake) version;
  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";

  # NOTE: Our sourceRoot is different from the default because the tests are in a subdirectory.
  inherit (cmake) src;
  sourceRoot = "${cmake.name}/Tests/${testGroup}/${testName}";

  brokenConditions = {
    "testCudaPackageType 'redist' requires CUDA 11.4+" =
      testCudaPackageType == "redist" && cudaOlder "11.4";
    "testCudaPackageType 'redist' requires cuda_nvcc" =
      testCudaPackageType == "redist" && cuda_nvcc == null;
    "testCudaPackageType 'redist' requires cuda_cudart" =
      testCudaPackageType == "redist" && cuda_cudart == null;
    "testCudaPackageType 'cudatoolkit' requires cudatoolkit" =
      testCudaPackageType == "cudatoolkit" && cudatoolkit == null;
    "testCudaPackageType 'cudatoolkit-legacy-runfile' requires cudatoolkit-legacy-runfile" =
      testCudaPackageType == "cudatoolkit-legacy-runfile" && cudatoolkit-legacy-runfile == null;
  } // testConfig.extraBrokenConditions;

  postPatch =
    # FindThreads, called as part of enabling the CUDA language only works if either C or CXX language is enabled.
    # https://github.com/Kitware/CMake/blob/cdc901797ac4ce0d1feeec454ecdd29e8ef5d4ff/Modules/FindCUDA.cmake#L1071
    # https://github.com/Kitware/CMake/blob/cdc901797ac4ce0d1feeec454ecdd29e8ef5d4ff/Modules/FindCUDAToolkit.cmake#L1146
    # Patch around that by enabling the CXX language on line three, as the first two lines declare the minimum
    # CMake version and the project name.
    optionalString testConfig.enableCXX ''
      sed -i '3i enable_language(CXX)' CMakeLists.txt
    ''
    # We need to modify CMakeLists.txt so it installs all executables and libraries.
    + ''
      cat <<'EOF' >>CMakeLists.txt
      # Install all targets
      get_directory_property(_targets DIRECTORY ''${CMAKE_CURRENT_SOURCE_DIR} BUILDSYSTEM_TARGETS)
      message(STATUS "Targets: ''${_targets}")
      foreach(target ''${_targets})
        install(TARGETS ''${target}
                RUNTIME DESTINATION bin
                LIBRARY DESTINATION lib
                ARCHIVE DESTINATION lib)
      endforeach()
      EOF
    '';

  nativeBuildInputs = [
    autoAddDriverRunpath
    cmake
  ] ++ baseNativeBuildInputs ++ testConfig.extraNativeBuildInputs;

  buildInputs = baseBuildInputs ++ testConfig.extraBuildInputs;

  passthru.tests.test = writeShellApplication {
    name = "run-${finalAttrs.name}";
    runtimeInputs = [ finalAttrs.finalPackage ];
    derivationArgs = {
      strictDeps = true;
      meta.mainProgram = "run-${finalAttrs.name}";
    };
    # Run the executables present in the bin directory.
    # If any of them fail, the test will fail.
    text = ''
      for test_bin in ${getBin finalAttrs.finalPackage}/bin/*
      do
        echo "Running test binary $test_bin"
        if ! $test_bin
        then
          echo "Failed to run test binary $test_bin"
          exit 1
        fi
        echo "Test binary $test_bin passed"
      done
      echo "All test binaries in ${finalAttrs.name} passed"
    '';
  };

  meta = {
    description = "CMake CUDA test ${testGroup}.${testName}";
    platforms = lib.platforms.linux;
    broken = any id (attrValues finalAttrs.brokenConditions);
    license = cmake.meta.license;
    maintainers = lib.teams.cuda.members;
  };
})
