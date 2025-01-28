{
  lib,
  stdenv,
  gcc13Stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # nativeBuildInputs
  cmake,
  ninja,

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
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abetlen";
    repo = "llama-cpp-python";
    tag = "v${version}";
    hash = "sha256-d5nMgpS7m6WEILs222ztwphoqkAezJ+qt6sVKSlpIYI=";
    fetchSubmodules = true;
  };
  # src = /home/gaetan/llama-cpp-python;

  patches = [
    # fix segfault when running tests due to missing default Metal devices
    (fetchpatch2 {
      url = "https://github.com/ggerganov/llama.cpp/commit/acd38efee316f3a5ed2e6afcbc5814807c347053.patch?full_index=1";
      stripLen = 1;
      extraPrefix = "vendor/llama.cpp/";
      hash = "sha256-71+Lpg9z5KPlaQTX9D85KS2LXFWLQNJJ18TJyyq3/pU=";
    })
  ];

  dontUseCmakeConfigure = true;
  SKBUILD_CMAKE_ARGS = lib.strings.concatStringsSep ";" (
    # Set GGML_NATIVE=off. Otherwise, cmake attempts to build with
    # -march=native* which is either a no-op (if cc-wrapper is able to ignore
    # it), or an attempt to build a non-reproducible binary.
    #
    # This issue was spotted when cmake rules appended feature modifiers to
    # -mcpu, breaking linux build as follows:
    #
    # cc1: error: unknown value ‘native+nodotprod+noi8mm+nosve’ for ‘-mcpu’
    [ "-DGGML_NATIVE=off" ]
    ++ lib.optionals cudaSupport [
      "-DGGML_CUDA=on"
      "-DCUDAToolkit_ROOT=${lib.getDev cudaPackages.cuda_nvcc}"
      "-DCMAKE_CUDA_COMPILER=${lib.getExe cudaPackages.cuda_nvcc}"
    ]
  );

  preBuild = ''
    export CMAKE_BUILD_PARALLEL_LEVEL="$NIX_BUILD_CORES"
  '';

  nativeBuildInputs = [
    cmake
    ninja
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

  pythonImportsCheck = [ "llama_cpp" ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
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
    maintainers = with lib.maintainers; [ kirillrdy ];
  };
}
