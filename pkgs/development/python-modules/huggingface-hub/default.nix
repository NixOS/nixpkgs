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
  # mcp
  mcp,

  # tests
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "huggingface-hub";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-At3FN+dplQ3L9B4vDZrEvREdwgepUvzWC7yeU6L5XY8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "typer-slim" "typer"
  '';

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
    typer
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
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      osbm
    ];
  };
})
