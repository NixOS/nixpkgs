{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  cargo,
  pkg-config,
  rustPlatform,
  rustc,

  # buildInputs
  openssl,

  # build-system
  setuptools-rust,
  setuptools-scm,

  # dependencies
  interegular,
  jsonschema,

  # optional-dependencies
  datasets,
  numpy,
  pydantic,
  scipy,
  torch,
  transformers,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "outlines-core";
<<<<<<< HEAD
  version = "0.2.13";
=======
  version = "0.2.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pyproject = true;

  src = fetchFromGitHub {
    owner = "dottxt-ai";
    repo = "outlines-core";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-mfw/cOLZPRcL3HWmrm/SyA0zDCPWr5F19EWIUdNu9jM=";
=======
    hash = "sha256-lLMTHFytJT2MhnzT0RlRCaSBPijA81fjxUqx4IGfVo8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail \
        'version = "0.0.0"' \
        'version = "${version}"'

    cp --no-preserve=mode ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [
    openssl.dev
  ];

  build-system = [
    setuptools-rust
    setuptools-scm
  ];

  dependencies = [
    interegular
    jsonschema
  ];

  optional-dependencies = {
    tests = [
      datasets
      numpy
      pydantic
      scipy
      torch
      transformers
    ];
  };

  pythonImportsCheck = [ "outlines_core" ];

  preCheck = ''
    rm -rf outlines_core
  '';

<<<<<<< HEAD
  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;
=======
  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTests = [
    # Tests that need to download from Hugging Face Hub.
    "test_complex_serialization"
    "test_create_fsm_index_tokenizer"
    "test_from_pretrained"
    "test_pickling_from_pretrained_with_revision"
    "test_reduced_vocabulary_with_rare_tokens"
  ];

  disabledTestPaths = [
    # Downloads from Hugging Face Hub
    "tests/test_kernels.py"
  ];

  meta = {
    description = "Structured text generation (core)";
    homepage = "https://github.com/outlines-dev/outlines-core";
    changelog = "https://github.com/dottxt-ai/outlines-core/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danieldk ];
  };
}
