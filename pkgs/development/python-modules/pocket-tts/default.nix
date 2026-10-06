{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  einops,
  fastapi,
  huggingface-hub,
  numpy,
  pydantic,
  python-multipart,
  requests,
  safetensors,
  scipy,
  sentencepiece,
  tokenizers,
  torch,
  typer,
  typing-extensions,
  uvicorn,

  # optional-dependencies
  soundfile,
  torchao,
}:

buildPythonPackage (finalAttrs: {
  pname = "pocket-tts";
  version = "3.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kyutai-labs";
    repo = "pocket-tts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5ymwdjYUcRbC8Qfscvg/8ebg3zyRrEbgiCLO0KyYBl4=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    einops
    fastapi
    huggingface-hub
    numpy
    pydantic
    python-multipart
    requests
    safetensors
    scipy
    sentencepiece
    tokenizers
    torch
    typer
    typing-extensions
    uvicorn
  ];

  optional-dependencies = {
    audio = [
      soundfile
    ];
    quantize = [
      torchao
    ];
  };

  pythonImportsCheck = [ "pocket_tts" ];

  # All tests are failing as the model cannot be downloaded from the sandbox
  doCheck = false;

  meta = {
    description = "Lightweight text-to-speech (TTS) application designed to run efficiently on CPUs";
    homepage = "https://github.com/kyutai-labs/pocket-tts";
    changelog = "https://github.com/kyutai-labs/pocket-tts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "pocket-tts";
  };
})
