{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  gitMinimal,

  # build-system
  certifi,
  cmake,
  packaging,
  pyyaml,
  setuptools,
  zstd,

  # dependencies
  # coremltools, (unpackaged)
  expecttest,
  flatbuffers,
  hydra-core,
  hypothesis,
  kgb,
  mpmath,
  numpy,
  omegaconf,
  pandas,
  parameterized,
  pytorch-tokenizers,
  ruamel-yaml,
  scikit-learn,
  sympy,
  tabulate,
  torch,
  torchao,
  typing-extensions,

  # tests
  pytest-json-report,
  pytest-rerunfailures,
  pytestCheckHook,
  torchaudio,
  torchtune,
  transformers,
  writableTmpDirAsHomeHook,
  yaspin,
}:
buildPythonPackage rec {
  pname = "executorch";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "executorch";
    tag = "v${version}";

    # The ExecuTorch repo must be cloned into a directory named exactly `executorch`.
    # See https://github.com/pytorch/executorch/issues/6475 for progress on a fix for this restriction.
    name = "executorch";

    fetchSubmodules = true;
    hash = "sha256-h+nmipFDO/cdPTQXrjM5EkH//wHKBAvlDIp6SBbGN/8=";
  };
  # src = /home/gaetan/nix/nixpkgs-packages/executorch;

  postPatch =
    # Hardcode the default flatc binary path to the nixpkgs flatc
    ''
      substituteInPlace exir/_serialize/_flatbuffer.py \
        --replace-fail \
          'flatc_path = "flatc"' \
          'flatc_path = "${lib.getExe pkgs.flatbuffers}"'
    ''
    # Relax build-system dependencies
    + ''
      substituteInPlace pyproject.toml \
        --replace-fail '"pip>=23",' "" \
        --replace-fail "cmake>=3.29,<4.0.0" "cmake"
    ''
    # CMake 4 dropped support of versions lower than 3.5, versions lower than 3.10 are deprecated.
    # https://github.com/NixOS/nixpkgs/issues/445447
    + ''
      substituteInPlace backends/xnnpack/third-party/pthreadpool/CMakeLists.txt \
        --replace-fail \
          "CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)" \
          "CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)"
    '';

  env = {
    BUILD_VERSION = version;
  };

  build-system = [
    certifi
    cmake
    packaging
    pyyaml
    setuptools
    zstd
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    gitMinimal
  ];

  pythonRemoveDeps = [
    # unpackaged
    "coremltools"

    # Test dependencies that should not be listed in runtime dependencies
    "pytest"
    "pytest-json-report"
    "pytest-rerunfailures"
    "pytest-xdist"
  ];
  pythonRelaxDeps = [
    "torchao"
  ];
  dependencies = [
    # coremltools (unpackaged)
    expecttest
    flatbuffers
    hydra-core
    hypothesis
    kgb
    mpmath
    numpy
    omegaconf
    packaging
    pandas
    parameterized
    pytorch-tokenizers
    pyyaml
    ruamel-yaml
    scikit-learn
    sympy
    tabulate
    torch
    torchao
    typing-extensions
  ];

  pythonImportsCheck = [ "executorch" ];

  nativeCheckInputs = [
    pytest-json-report
    pytest-rerunfailures
    pytestCheckHook
    torchaudio
    torchtune
    transformers
    writableTmpDirAsHomeHook
    yaspin
  ];

  disabledTestPaths = [
    # Require unpackaged coremltools
    "backends/apple/coreml/*"
    "export/tests/test_target_recipes.py"

    # Try to download models from HuggingFace hub
    "extension/llm/tokenizers/test/test_hf_tokenizer.py"
  ];

  disabledTests = [
    # RuntimeError: Failed to execute method forward, error: 0x20
    # [method.cpp:70] Backend BackendWithCompilerDemo is not registered
    "test_compatibility_in_runtime"
    "test_compatibility_in_runtime_edge_program_manager"
    "test_emit_lowered_backend_module_end_to_end"
    "test_multi_method_end_to_end"

    # AssertionError (Numerical comparison fails)
    "test_sdpa_with_cache_seq_len_13"
    "test_sdpa_with_custom_quantized_seq_len_130_gqa"

    # Try to download models from the internet
    "test_all_models_with_recipes"
    "test_dl3_export_to_executorch"
    "test_efficient_sam_export_to_executorch"
    "test_ic3_export_to_executorch"
    "test_mobilenet_v3"
    "test_mobilenet_v3_xnnpack"
    "test_mv2_export_to_executorch"
    "test_mv3_export_to_executorch"
    "test_resnet18_export_to_executorch"
    "test_resnet50_export_to_executorch"
    "test_vit_export_to_executorch"
  ];

  meta = {
    description = "On-device AI across mobile, embedded and edge for PyTorch";
    homepage = "https://github.com/pytorch/executorch";
    changelog = "https://github.com/pytorch/executorch/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # Many tests segfault. Supporting this platform will need additional work
      "aarch64-linux"
    ];
  };
}
