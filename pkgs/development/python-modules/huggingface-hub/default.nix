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
  tqdm,
  typer,
  typing-extensions,

  # optional-dependencies
  # torch
  torch,
  safetensors,
  # fastai
  toml,
  fastai,
  fastcore,
  # gradio
  gradio,
  requests,
  # oauth
  authlib,
  fastapi,
  itsdangerous,
  # mcp
  mcp,

  # tests
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "huggingface-hub";
  version = "1.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GuTsoz7ow3A/PJyU3L/xLp56r3RVx5O1YH3nr3T4u7U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    fsspec
    hf-xet
    httpx
    packaging
    pyyaml
    tqdm
    typer
    typing-extensions
  ];

  optional-dependencies = {
    all = [

    ];
    fastai = [
      toml
      fastai
      fastcore
    ];
    gradio = [
      gradio
      requests
    ];
    hf_xet = [
      hf-xet
    ];
    mcp = [
      mcp
    ];
    oauth = [
      authlib
      fastapi
      httpx
      itsdangerous
    ];
    torch = [
      torch
      safetensors
    ]
    ++ safetensors.optional-dependencies.torch;
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
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      osbm
    ];
  };
})
