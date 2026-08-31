{
  lib,
  buildPythonPackage,
  conformer,
  diffusers,
  fetchFromGitHub,
  gradio,
  librosa,
  numpy,
  omegaconf,
  pykakasi,
  pyloudnorm,
  resemble-perth,
  s3tokenizer,
  safetensors,
  setuptools,
  spacy-pkuseg,
  torch,
  torchaudio,
  transformers,
}:

buildPythonPackage {
  pname = "chatterbox-tts";
  version = "0.1.3-unstable-2026-07-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "resemble-ai";
    repo = "chatterbox";
    rev = "5de7a54aa4e5e2baadb0182dde554908b48b85c2";
    hash = "sha256-5PFf2dDiAw5QiNTzqJmvPom2gMQTs12ibIrDbZ9KtKU=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "diffusers"
    "gradio"
    "librosa"
    "safetensors"
    "torch"
    "torchaudio"
    "transformers"
  ];

  dependencies = [
    conformer
    diffusers
    gradio
    librosa
    numpy
    omegaconf
    pykakasi
    pyloudnorm
    resemble-perth
    s3tokenizer
    safetensors
    spacy-pkuseg
    torch
    torchaudio
    transformers
  ];

  postFixup = ''
    export NUMBA_CACHE_DIR=$TMPDIR
  '';

  pythonImportsCheck = [ "chatterbox" ];

  # has no tests
  doCheck = false;

  meta = {
    description = "Open Source TTS and Voice Conversion by Resemble AI";
    homepage = "https://github.com/resemble-ai/chatterbox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
