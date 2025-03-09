{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  ninja,

  # build-system
  pathspec,
  pyproject-metadata,
  scikit-build-core,

  # buildInputs
  apple-sdk_11,

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
buildPythonPackage rec {
  pname = "llama-cpp-python";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abetlen";
    repo = "llama-cpp-python";
    tag = "v${version}";
    hash = "sha256-+LBq+rCqOsvGnhTL1UoCcAwvDt8Zo9hlaa4KibFFDag=";
    fetchSubmodules = true;
  };
  # src = /home/gaetan/llama-cpp-python;

  dontUseCmakeConfigure = true;
  SKBUILD_CMAKE_ARGS = lib.strings.concatStringsSep ";" (
    lib.optionals cudaSupport [
      "-DGGML_CUDA=on"
      "-DCUDAToolkit_ROOT=${lib.getDev cudaPackages.cuda_nvcc}"
      "-DCMAKE_CUDA_COMPILER=${lib.getExe cudaPackages.cuda_nvcc}"
    ]
  );

  nativeBuildInputs = [
    cmake
    ninja
  ];

  build-system = [
    pathspec
    pyproject-metadata
    scikit-build-core
  ];

  buildInputs =
    lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime.h
        cuda_cccl # <thrust/*>
        libcublas # cublas_v2.h
      ]
    )
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
    ];

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
    tests.llama-cpp-python = llama-cpp-python.override { cudaSupport = true; };
  };

  meta = {
    description = "Python bindings for llama.cpp";
    homepage = "https://github.com/abetlen/llama-cpp-python";
    changelog = "https://github.com/abetlen/llama-cpp-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kirillrdy ];
    badPlatforms = [
      # Segfaults during tests:
      # tests/test_llama.py .Fatal Python error: Segmentation fault
      # Current thread 0x00000001f3decf40 (most recent call first):
      #   File "/private/tmp/nix-build-python3.12-llama-cpp-python-0.3.2.drv-0/source/llama_cpp/_internals.py", line 51 in __init__
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
