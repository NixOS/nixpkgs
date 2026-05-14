{
  _cuda,
  addDriverRunpath,
  backendStdenv,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvrtc,
  cudaNamePrefix,
  cudnn,
  fetchFromGitHub,
  flags,
  gtest,
  lib,
  libcublas,
  libcurand,
  ninja,
  python3Packages,
  # Options
  pythonSupport ? true,
  enableF16C ? false,
  enableTools ? false,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (_cuda.lib) _mkMetaBadPlatforms;
  inherit (lib) licenses maintainers teams;
  inherit (lib.asserts) assertMsg;
  inherit (lib.attrsets) getBin;
  inherit (lib.lists) all optionals;
  inherit (lib.strings)
    cmakeBool
    cmakeFeature
    optionalString
    versionAtLeast
    ;
  inherit (lib.trivial) flip;
in
# TODO: Tests.
assert assertMsg (!enableTools) "enableTools is not yet implemented";
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "cutlass";
  version = "3.9.2";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-teziPNA9csYvhkG5t2ht8W8x5+1YGGbHm8VKx4JoxgI=";
  };

  # TODO: As a header-only library, we should make sure we have an `include` directory or similar which is not a
  # superset of the `out` (`bin`) or `dev` outputs (whih is what the multiple-outputs setup hook does by default).
  outputs = [ "out" ] ++ optionals pythonSupport [ "dist" ];

  nativeBuildInputs = [
    cuda_nvcc
    cmake
    ninja
    python3Packages.python # Python is always required
  ]
  ++ optionals pythonSupport (
    with python3Packages;
    [
      build
      pythonOutputDistHook
      setuptools
    ]
  );

  postPatch =
    # Prepend some commands to the CUDA.cmake file so it can find the CUDA libraries using CMake's FindCUDAToolkit
    # module. These target names are used throughout the project; I (@connorbaker) did not choose them.
    ''
      nixLog "patching CUDA.cmake to use FindCUDAToolkit"
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
    ''
    # Patch cutlass to use the provided NVCC.
    # '_CUDA_INSTALL_PATH = os.getenv("CUDA_INSTALL_PATH", _cuda_install_path_from_nvcc())' \
    # '_CUDA_INSTALL_PATH = "${getBin cuda_nvcc}"'
    + ''
      nixLog "patching python bindings to make cuda_install_path fail"
      substituteInPlace ./python/cutlass/__init__.py \
        --replace-fail \
          'def cuda_install_path():' \
      '
      def cuda_install_path():
          raise RuntimeException("not supported with Nixpkgs CUDA packaging")
      '
    ''
    # Patch the python bindings to use environment variables set by Nixpkgs.
    # https://github.com/NVIDIA/cutlass/blob/e94e888df3551224738bfa505787b515eae8352f/python/cutlass/backend/compiler.py#L80
    # https://github.com/NVIDIA/cutlass/blob/e94e888df3551224738bfa505787b515eae8352f/python/cutlass/backend/compiler.py#L81
    # https://github.com/NVIDIA/cutlass/blob/e94e888df3551224738bfa505787b515eae8352f/python/cutlass/backend/compiler.py#L317
    # https://github.com/NVIDIA/cutlass/blob/e94e888df3551224738bfa505787b515eae8352f/python/cutlass/backend/compiler.py#L319
    # https://github.com/NVIDIA/cutlass/blob/e94e888df3551224738bfa505787b515eae8352f/python/cutlass/backend/compiler.py#L344
    # https://github.com/NVIDIA/cutlass/blob/e94e888df3551224738bfa505787b515eae8352f/python/cutlass/backend/compiler.py#L360
    + ''
      nixLog "patching python bindings to use environment variables"
      substituteInPlace ./python/cutlass/backend/compiler.py \
        --replace-fail \
          'self.include_paths = include_paths' \
          'self.include_paths = include_paths + [root + "/include" for root in os.getenv("CUDAToolkit_ROOT").split(";")]' \
        --replace-fail \
          'self.flags = flags' \
          'self.flags = flags + ["-L" + root + "/lib" for root in os.getenv("CUDAToolkit_ROOT").split(";")]' \
        --replace-fail \
          "\''${cuda_install_path}/bin/nvcc" \
          '${getBin cuda_nvcc}/bin/nvcc' \
        --replace-fail \
          '"cuda_install_path": cuda_install_path(),' \
          "" \
        --replace-fail \
          'f"{cuda_install_path()}/bin/nvcc"' \
          '"${getBin cuda_nvcc}/bin/nvcc"' \
        --replace-fail \
          'cuda_install_path() + "/include",' \
          ""
    '';

  enableParallelBuilding = true;

  buildInputs = [
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
  ];

  postBuild = lib.optionalString pythonSupport ''
    pushd "$NIX_BUILD_TOP/$sourceRoot"
    nixLog "building Python wheel"
    pyproject-build \
      --no-isolation \
      --outdir "$NIX_BUILD_TOP/$sourceRoot/''${cmakeBuildDir:?}/dist/" \
      --wheel
    popd >/dev/null
  '';

  doCheck = false;

  checkInputs = [ gtest ];

  # NOTE: Because the test cases immediately create and try to run the binaries, we don't have an opportunity
  # to patch them with autoAddDriverRunpath. To get around this, we add the driver runpath to the environment.
  # TODO: This would break Jetson when using cuda_compat, as it must come first.
  preCheck = optionalString finalAttrs.doCheck ''
    export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
  '';

  # This is *not* a derivation you want to build on a small machine.
  requiredSystemFeatures = optionals finalAttrs.doCheck [
    "big-parallel"
    "cuda"
  ];

  passthru = {
    updateScript = gitUpdater {
      inherit (finalAttrs) pname version;
      rev-prefix = "v";
    };
    # TODO:
    # tests.test = cutlass.overrideAttrs { doCheck = true; };

    # Include required architectures in compatibility check.
    # https://github.com/NVIDIA/cutlass/tree/main?tab=readme-ov-file#compatibility
    platformAssertions = [
      {
        message = "all capabilities are >= 7.0 (${builtins.toJSON flags.cudaCapabilities})";
        assertion = all (flip versionAtLeast "7.0") flags.cudaCapabilities;
      }
    ];
  };

  meta = {
    description = "CUDA Templates for Linear Algebra Subroutines";
    homepage = "https://github.com/NVIDIA/cutlass";
    license = licenses.asl20;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    badPlatforms = _mkMetaBadPlatforms finalAttrs;
    maintainers = [ maintainers.connorbaker ];
    teams = [ teams.cuda ];
  };
})
