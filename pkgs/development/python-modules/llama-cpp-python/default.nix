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
  scikit-build-core,

  # dependencies
  diskcache,
  jinja2,
  llama-cpp ? null,
  llama-cpp-vulkan,
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
  useVendoredLlamaCpp = llama-cpp == null;
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

  postPatch = lib.optionalString (llama-cpp != null) ''
    for module in _ggml llama_cpp llava_cpp mtmd_cpp; do
      substituteInPlace llama_cpp/$module.py \
        --replace-fail '_base_path = pathlib.Path(os.path.abspath(os.path.dirname(__file__)))' '_base_path = pathlib.Path("${llama-cpp'}")'
    done
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
  SKBUILD_CMAKE_ARGS =
    if useVendoredLlamaCpp then
      (lib.strings.concatStringsSep ";" (
        # Set GGML_NATIVE=off. Otherwise, cmake attempts to build with
        # -march=native* which is either a no-op (if cc-wrapper is able to ignore
        # it), or an attempt to build a non-reproducible binary.
        #
        # This issue was spotted when cmake rules appended feature modifiers to
        # -mcpu, breaking linux build as follows:
        #
        # cc1: error: unknown value ‘native+nodotprod+noi8mm+nosve’ for ‘-mcpu’
        [
          "-DGGML_NATIVE=off"
          "-DGGML_BUILD_NUMBER=1"
        ]
        ++ lib.optionals cudaSupport [
          "-DGGML_CUDA=on"
          "-DCUDAToolkit_ROOT=${lib.getDev cudaPackages.cuda_nvcc}"
          "-DCMAKE_CUDA_COMPILER=${lib.getExe cudaPackages.cuda_nvcc}"
        ]
      ))
    else
      "-DLLAMA_BUILD=off";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  build-system = [
    scikit-build-core
  ];

  buildInputs = lib.optional useVendoredLlamaCpp llama-cpp';

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

  pythonImportsCheck = [
    "llama_cpp"
    "llama_cpp._ggml"
    "llama_cpp.llama_cpp"
    "llama_cpp.mtmd_cpp"
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      allowedVersions = "^[.0-9]+$";
    };
    tests = {
      withLlama = llama-cpp-python.override {
        inherit llama-cpp;
      };
      withVulkan = llama-cpp-python.override {
        llama-cpp = llama-cpp-vulkan;
      };
    }
    // (lib.optionalAttrs stdenv.hostPlatform.isLinux {
      withVendoredLlamaCuda = llama-cpp-python.override {
        cudaSupport = true;
      };
      withCuda = llama-cpp-python.override {
        llama-cpp = llama-cpp'.override {
          cudaSupport = true;
        };
      };
    });
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
