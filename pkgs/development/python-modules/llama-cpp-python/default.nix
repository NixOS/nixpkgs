{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  llama-cpp,
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
  llama-cpp' = llama-cpp.override {
    inherit cudaSupport cudaPackages;
  };
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

  postPatch = ''
    substituteInPlace llama_cpp/llama_cpp.py \
      --replace-fail '_base_path = pathlib.Path(os.path.abspath(os.path.dirname(__file__)))' '_base_path = pathlib.Path("${llama-cpp'}")'
  '';

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
  SKBUILD_CMAKE_ARGS = "-DLLAMA_BUILD=off";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  build-system = [
    pathspec
    pyproject-metadata
    scikit-build-core
  ];

  buildInputs = [ llama-cpp' ];

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
    updateScript = gitUpdater {
      rev-prefix = "v";
      allowedVersions = "^[.0-9]+$";
    };
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
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
