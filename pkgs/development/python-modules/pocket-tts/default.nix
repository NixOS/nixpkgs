{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  beartype,
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
  torch,
  typer,
  typing-extensions,
  uvicorn,

  # optional-dependencies
  soundfile,
}:

buildPythonPackage (finalAttrs: {
  pname = "pocket-tts";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kyutai-labs";
    repo = "pocket-tts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9Y/q/6Ti/oTyOgRzK+UT+LSM/iH3RGey+XojxbPvPS0=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "beartype"
    "python-multipart"
  ];
  dependencies = [
    beartype
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
    torch
    typer
    typing-extensions
    uvicorn
  ];

  optional-dependencies = {
    audio = [
      soundfile
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
