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
  httpx,
  packaging,
  pyyaml,
  shellingham,
  tqdm,
  typer-slim,
  typing-extensions,

  # optional-dependencies
  # torch
  torch,
  safetensors,
  # fastai
  toml,
  fastai,
  fastcore,
  # mcp
  mcp,

  # tests
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    tag = "v${version}";
    hash = "sha256-Mn6UNdYOp+ZTC/U/dtBVaEnC6zFEjZRhBnZYTPlmkoM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    fsspec
    hf-xet
    httpx
    packaging
    pyyaml
    shellingham
    tqdm
    typer-slim
    typing-extensions
  ];

  optional-dependencies = {
    all = [

    ];
    torch = [
      torch
      safetensors
    ]
    ++ safetensors.optional-dependencies.torch;
    fastai = [
      toml
      fastai
      fastcore
    ];
    hf_xet = [
      hf-xet
    ];
    mcp = [
      mcp
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
