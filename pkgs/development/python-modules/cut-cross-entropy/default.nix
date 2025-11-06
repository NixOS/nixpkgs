{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  torch,
  triton,

  # optional-dependencies
  accelerate,
  datasets,
  fire,
  huggingface-hub,
  pandas,
  pytestCheckHook,
  tqdm,
  transformers,
}:

buildPythonPackage {
  pname = "cut-cross-entropy";
  version = "25.7.2";
  pyproject = true;

  # The `ml-cross-entropy` Pypi comes from a third-party.
  # Apple recommends installing from the repo's main branch directly
  src = fetchFromGitHub {
    owner = "apple";
    repo = "ml-cross-entropy";
    rev = "b19a424ed30a05b8261cfa84d83b2601a9454c67"; # no tags
    hash = "sha256-AwUqKiI7XjEOZ7ofjQCOsqvxHyTFD4RZ70odPyxxntc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    torch
    triton
  ];

  optional-dependencies = {
    transformers = [ transformers ];
    all = [
      accelerate
      datasets
      fire
      huggingface-hub
      pandas
      tqdm
      transformers
    ];
    # `deepspeed` is not yet packaged in nixpkgs
    # ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    #   deepspeed
    # ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_vocab_parallel" # Requires CUDA but does not use pytest.skip
  ];

  pythonImportsCheck = [
    "cut_cross_entropy"
  ];

  meta = {
    description = "Memory-efficient cross-entropy loss implementation using Cut Cross-Entropy (CCE)";
    homepage = "https://github.com/apple/ml-cross-entropy";
    license = lib.licenses.aml;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
