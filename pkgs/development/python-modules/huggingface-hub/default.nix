{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  filelock,
  fsspec,
  hf-xet,
  packaging,
  pyyaml,
  requests,
  tqdm,
  typing-extensions,

  # optional-dependencies
  # cli
  inquirerpy,
  # inference
  aiohttp,
  # torch
  torch,
  safetensors,
  # hf_transfer
  hf-transfer,
  # fastai
  toml,
  fastai,
  fastcore,
  # tensorflow
  tensorflow,
  pydot,
  graphviz,
  # tensorflow-testing
  keras,

  # tests
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "0.35.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    tag = "v${version}";
    hash = "sha256-KOq3qxt3AyWQIOG0+HUbNr15u85tyTEstoUkYBFkpC4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    fsspec
    hf-xet
    packaging
    pyyaml
    requests
    tqdm
    typing-extensions
  ];

  optional-dependencies = {
    all = [

    ];
    cli = [
      inquirerpy
    ];
    inference = [
      aiohttp
    ];
    torch = [
      torch
      safetensors
    ]
    ++ safetensors.optional-dependencies.torch;
    hf_transfer = [
      hf-transfer
    ];
    fastai = [
      toml
      fastai
      fastcore
    ];
    tensorflow = [
      tensorflow
      pydot
      graphviz
    ];
    tensorflow-testing = [
      tensorflow
      keras
    ];
    hf_xet = [
      hf-xet
    ];
  };

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  pythonImportsCheck = [ "huggingface_hub" ];

  meta = {
    description = "Download and publish models and other files on the huggingface.co hub";
    mainProgram = "hf";
    homepage = "https://github.com/huggingface/huggingface_hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      osbm
    ];
  };
}
