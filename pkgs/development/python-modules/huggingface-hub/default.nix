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
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "0.34.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    tag = "v${version}";
    hash = "sha256-Cy/ZEqSBY5Aam+q8DBuaaE52Jtf4MB1kcRVyqfXuigo=";
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

  # Tests require network access.
  doCheck = false;

  pythonImportsCheck = [ "huggingface_hub" ];

  meta = {
    description = "Download and publish models and other files on the huggingface.co hub";
    mainProgram = "huggingface-cli";
    homepage = "https://github.com/huggingface/huggingface_hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
