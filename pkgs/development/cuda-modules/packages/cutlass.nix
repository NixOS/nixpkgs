{
  addDriverRunpath,
  autoAddDriverRunpath,
  backendStdenv,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvrtc,
  cudaMajorMinorVersion,
  cudaOlder,
  cudnn,
  cutlass,
  fetchFromGitHub,
  fetchpatch2,
  flags,
  gtest,
  lib,
  libcublas,
  libcurand,
  ninja,
  python3,
  # Options
  enableF16C ? false,
  enableTools ? false,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.strings) cmakeBool cmakeFeature optionalString;
in
# TODO: This can also be packaged for Python!
backendStdenv.mkDerivation (finalAttrs: {
  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "cutlass";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-D/s7eYsa5l/mfx73tE4mnFcTQdYqGmXa9d9TCryw4e4=";
  };

  strictDeps = true;

  # TODO: As a header-only library, we should make sure we have an `include` directory or similar which is not a
  # superset of the `out` (`bin`) or `dev` outputs (whih is what the multiple-outputs setup hook does by default).
  outputs = [ "out" ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    cuda_nvcc
    cmake
    ninja
    python3
  ];

  patches =
    # Enable use of the system googletest.
    # NOTE: Revisit these when 3.5.1 releases, as it may be included.
    [
      (fetchpatch2 {
        name = "support-system-googletest.patch";
        url = "https://github.com/NVIDIA/cutlass/pull/1469/commits/60923063b39c22982e56c304e132e59b358f4814.patch";
        hash = "sha256-q44SVpC7i91onsBDYKKBob5YqTPmXHRFgImnKpeVKpQ=";
      })
      (fetchpatch2 {
        name = "create-working-directory-for-tests-explicitly.patch";
        url = "https://github.com/NVIDIA/cutlass/pull/1469/commits/1093c4f90df6083146681e3c39b0c53611978c5f.patch";
        hash = "sha256-AYJsr+y5ntSWuV7+b/NRRY+fXE5SFN28BdZZqWXoElc=";
      })
    ];

  postPatch =
    # Prepend some commands to the CUDA.cmake file so it can find the CUDA libraries using CMake's FindCUDAToolkit
    # module. These target names are used throughout the project; I (@connorbaker) did not choose them.
    ''
      mv ./CUDA.cmake ./_CUDA_Append.cmake
      cat > ./_CUDA_Prepend.cmake <<'EOF'
      find_package(CUDAToolkit REQUIRED)
      foreach(_target cudart cuda_driver nvrtc)
        if (NOT TARGET CUDA::''${_target})
          message(FATAL_ERROR "''${_target} Not Found")
        endif()
        message(STATUS "''${_target} library: ''${CUDA_''${_target}_LIBRARY}")
        add_library(''${_target} ALIAS CUDA::''${_target})
      endforeach()
      EOF
      cat ./_CUDA_Prepend.cmake ./_CUDA_Append.cmake > ./CUDA.cmake
    '';

  enableParallelBuilding = true;

  buildInputs =
    [
      cuda_cudart
      cuda_nvrtc
      libcurand
    ]
    ++ optionals enableTools [
      cudnn
      libcublas
    ];

  cmakeFlags = [
    (cmakeFeature "CUTLASS_NVCC_ARCHS" flags.cmakeCudaArchitecturesString)
    (cmakeBool "CUTLASS_ENABLE_EXAMPLES" false)

    # Tests.
    (cmakeBool "CUTLASS_ENABLE_TESTS" finalAttrs.doCheck)
    (cmakeBool "CUTLASS_ENABLE_GTEST_UNIT_TESTS" finalAttrs.doCheck)
    (cmakeBool "CUTLASS_USE_SYSTEM_GOOGLETEST" true)

    # NOTE: Both CUDNN and CUBLAS can be used by the examples and the profiler. Since they are large dependencies, they
    #       are disabled by default.
    (cmakeBool "CUTLASS_ENABLE_TOOLS" enableTools)
    (cmakeBool "CUTLASS_ENABLE_CUBLAS" enableTools)
    (cmakeBool "CUTLASS_ENABLE_CUDNN" enableTools)

    # NOTE: Requires x86_64 and hardware support.
    (cmakeBool "CUTLASS_ENABLE_F16C" enableF16C)

    # TODO: Unity builds are supposed to reduce build time, but this seems to just reduce the number of tasks
    # generated?
    # NOTE: Good explanation of unity builds:
    #       https://www.methodpark.de/blog/how-to-speed-up-clang-tidy-with-unity-builds.
    (cmakeBool "CUTLASS_UNITY_BUILD_ENABLED" false)

    # NOTE: Can change the size of the executables
    (cmakeBool "CUTLASS_NVCC_EMBED_CUBIN" true)
    (cmakeBool "CUTLASS_NVCC_EMBED_PTX" true)
  ];

  doCheck = false;

  checkInputs = [ gtest ];

  # NOTE: Because the test cases immediately create and try to run the binaries, we don't have an opportunity
  # to patch them with autoAddDriverRunpath. To get around this, we add the driver runpath to the environment.
  preCheck = optionalString finalAttrs.doCheck ''
    export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
  '';

  # This is *not* a derivation you want to build on a small machine.
  requiredSystemFeatures = optionals finalAttrs.doCheck [
    "big-parallel"
    "cuda"
  ];

  passthru =
    let
      cutlassShowLinkTimes = cutlass.overrideAttrs (prevAttrs: {
        # Set RULE_LAUNCH_LINK so CMake adds a message to the linker command to show the link times.
        postPatch =
          prevAttrs.postPatch
          + ''
            sed -i '1i set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK "''${CMAKE_COMMAND} -E time")' ./CUDA.cmake
          '';
      });
    in
    {
      updateScript = gitUpdater {
        inherit (finalAttrs) pname version;
        rev-prefix = "v";
      };
      # TODO: These can be removed.
      tests.withGpu = cutlass.overrideAttrs { doCheck = true; };
      showLinkTimesWithDefaultLinker = cutlassShowLinkTimes;
      showLinkTimesWithMoldLinker = cutlassShowLinkTimes.override {
        backendStdenv = backendStdenv.withMoldLinker;
      };
    };

  meta = with lib; {
    description = "CUDA Templates for Linear Algebra Subroutines";
    homepage = "https://github.com/NVIDIA/cutlass";
    license = licenses.asl20;
    broken = cudaOlder "11.4";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ connorbaker ] ++ teams.cuda.members;
  };
})
