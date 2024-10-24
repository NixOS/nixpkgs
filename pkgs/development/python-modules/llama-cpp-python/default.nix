{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  ninja,
  pathspec,
  pyproject-metadata,
  pytestCheckHook,
  pythonOlder,
  scikit-build-core,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

  diskcache,
  jinja2,
  numpy,
  typing-extensions,
  scipy,
  huggingface-hub,
}:

buildPythonPackage rec {
  pname = "llama-cpp-python";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "abetlen";
    repo = "llama-cpp-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-eO1zvNJZBE5BCnbgbh00tFIRWBCWor1lIsrLXs/HFds=";
    fetchSubmodules = true;
  };

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

  propagatedBuildInputs = [
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

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Python bindings for llama.cpp";
    homepage = "https://github.com/abetlen/llama-cpp-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kirillrdy ];
  };
}
