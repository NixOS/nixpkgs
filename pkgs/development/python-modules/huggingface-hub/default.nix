{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  click,
  filelock,
  fsspec,
  hf-xet,
  httpx,
  packaging,
  pyyaml,
  tqdm,
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
  version = "1.28.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nUdBUBLM2NivmQiumY36GfUYREl+4hRszlJEM6ryj1w=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "click"
  ];
  dependencies = [
    click
    filelock
    fsspec
    hf-xet
    httpx
    packaging
    pyyaml
    tqdm
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
