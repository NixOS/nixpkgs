{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  cargo,
  pkg-config,
  rustPlatform,
  rustc,
  openssl,
  setuptools-rust,
  setuptools-scm,
  interegular,
  jsonschema,
  datasets,
  numpy,
  pytestCheckHook,
  pydantic,
  scipy,
  torch,
  transformers,
}:

buildPythonPackage rec {
  pname = "outlines-core";
  version = "0.1.26";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "outlines_core";
    hash = "sha256-SBxDATQed8yPGDLWFnhK201GG0/sZYeOfA0sunFjoYk=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp --no-preserve=mode ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
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

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # Tests that need to download from Hugging Face Hub.
    "test_complex_serialization"
    "test_create_fsm_index_tokenizer"
    "test_reduced_vocabulary_with_rare_tokens"
  ];

  pythonImportsCheck = [ "outlines_core" ];

  meta = {
    description = "Structured text generation (core)";
    homepage = "https://github.com/outlines-dev/outlines-core";
    changelog = "https://github.com/dottxt-ai/outlines-core/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danieldk ];
  };
}
