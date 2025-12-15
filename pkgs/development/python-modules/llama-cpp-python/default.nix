{
  lib,
  stdenv,
  gcc13Stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  ninja,
  autoAddDriverRunpath,

  # build-system
  pathspec,
  pyproject-metadata,
  scikit-build-core,

  # dependencies
  diskcache,
  jinja2,
  numpy,
  typing-extensions,

  # tests
  scipy,
  huggingface-hub,

  # passthru
  gitUpdater,
  pytestCheckHook,
  llama-cpp-python,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

}:
let
  stdenvTarget = if cudaSupport then gcc13Stdenv else stdenv;
in
buildPythonPackage rec {
  pname = "llama-cpp-python";
  version = "0.3.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abetlen";
    repo = "llama-cpp-python";
    tag = "v${version}";
    hash = "sha256-EUDtCv86J4bznsTqNsdgj1IYkAu83cf+RydFTUb2NEE=";
    fetchSubmodules = true;
  };
  # src = /home/gaetan/llama-cpp-python;

  patches = [
    # Fix test failure on a machine with no metal devices (e.g. nix-community darwin builder)
    # https://github.com/ggml-org/llama.cpp/pull/15531
    (fetchpatch {
      url = "https://github.com/ggml-org/llama.cpp/pull/15531/commits/63a83ffefe4d478ebadff89300a0a3c5d660f56a.patch";
      stripLen = 1;
      extraPrefix = "vendor/llama.cpp/";
      hash = "sha256-9LGnzviBgYYOOww8lhiLXf7xgd/EtxRXGQMredOO4qM=";
    })
  ];

  dontUseCmakeConfigure = true;
  cmakeFlags = [
    # Set GGML_NATIVE=off. Otherwise, cmake attempts to build with
    # -march=native* which is either a no-op (if cc-wrapper is able to ignore
    # it), or an attempt to build a non-reproducible binary.
    #
    # This issue was spotted when cmake rules appended feature modifiers to
    # -mcpu, breaking linux build as follows:
    #
    # cc1: error: unknown value ‘native+nodotprod+noi8mm+nosve’ for ‘-mcpu’
    (lib.cmakeBool "GGML_NATIVE" false)
    (lib.cmakeFeature "GGML_BUILD_NUMBER" "1")
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeBool "GGML_CUDA" true)
    (lib.cmakeFeature "CUDAToolkit_ROOT" "${lib.getDev cudaPackages.cuda_nvcc}")
    (lib.cmakeFeature "CMAKE_CUDA_COMPILER" "${lib.getExe cudaPackages.cuda_nvcc}")
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  build-system = [
    pathspec
    pyproject-metadata
    scikit-build-core
  ];

  buildInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart # cuda_runtime.h
      cuda_cccl # <thrust/*>
      libcublas # cublas_v2.h
    ]
  );

  stdenv = stdenvTarget;

  dependencies = [
    diskcache
    jinja2
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
    huggingface-hub
  ];

  disabledTests = [
    # tries to download model from huggingface-hub
    "test_real_model"
    "test_real_llama"
  ];

  pythonImportsCheck = lib.optionals (!cudaSupport) [
    # `libllama.so` is loaded at import time, and failing when cudaSupport is enabled as the cuda
    # driver is missing in the sandbox:
    # RuntimeError: Failed to load shared library '/nix/store/...-python3.13-llama-cpp-python-0.3.16/lib/python3.13/site-packages/llama_cpp/lib/libllama.so':
    # libcuda.so.1: cannot open shared object file: No such file or directory
    "llama_cpp"
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      allowedVersions = "^[.0-9]+$";
    };
    tests = lib.optionalAttrs stdenvTarget.hostPlatform.isLinux {
      withCuda = llama-cpp-python.override {
        cudaSupport = true;
      };
    };
  };

  meta = {
    description = "Python bindings for llama.cpp";
    homepage = "https://github.com/abetlen/llama-cpp-python";
    changelog = "https://github.com/abetlen/llama-cpp-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      booxter
      kirillrdy
    ];
  };
}
