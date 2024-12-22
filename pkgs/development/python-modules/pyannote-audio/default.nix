{
  lib,
  asteroid-filterbanks,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  huggingface-hub,
  hydra-core,
  numpy,
  omegaconf,
  pyannote-core,
  pyannote-database,
  pyannote-metrics,
  pyannote-pipeline,
  pyscaffold,
  pythonOlder,
  pytorch-lightning,
  pytorch-metric-learning,
  rich,
  semver,
  setuptools,
  soundfile,
  speechbrain,
  tensorboardx,
  torch-audiomentations,
  torch,
  torchaudio,
  torchmetrics,
  typer,
}:

buildPythonPackage rec {
  pname = "pyannote-audio";
  version = "3.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-audio";
    rev = "refs/tags/${version}";
    hash = "sha256-85whRoc3JoDSE4DqivY/3hfvLHcvgsubR/DLCPtLEP0=";
    fetchSubmodules = true;
  };

  pythonRelaxDeps = [ "torchaudio" ];

  build-system = [
    pyscaffold
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "pyscaffold>=3.2a0,<3.3a0" "pyscaffold"
    substituteInPlace requirements.txt \
      --replace-fail "lightning" "pytorch-lightning"
  '';

  dependencies = [
    asteroid-filterbanks
    einops
    huggingface-hub
    omegaconf
    pyannote-core
    pyannote-database
    pyannote-metrics
    pyannote-pipeline
    pytorch-metric-learning
    rich
    semver
    soundfile
    speechbrain
    tensorboardx
    torch
    torch-audiomentations
    torchaudio
    torchmetrics
    numpy
    pytorch-lightning
  ];

  optional-dependencies = {
    cli = [
      hydra-core
      typer
    ];
  };

  pythonImportsCheck = [ "pyannote.audio" ];

  meta = with lib; {
    description = "Neural building blocks for speaker diarization: speech activity detection, speaker change detection, overlapped speech detection, speaker embedding";
    homepage = "https://github.com/pyannote/pyannote-audio";
    changelog = "https://github.com/pyannote/pyannote-audio/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
