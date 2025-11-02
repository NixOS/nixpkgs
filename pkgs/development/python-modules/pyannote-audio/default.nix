{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pyscaffold,
  setuptools,

  # dependencies
  asteroid-filterbanks,
  einops,
  huggingface-hub,
  numpy,
  omegaconf,
  pyannote-core,
  pyannote-database,
  pyannote-metrics,
  pyannote-pipeline,
  pytorch-lightning,
  pytorch-metric-learning,
  rich,
  semver,
  soundfile,
  speechbrain,
  tensorboardx,
  torch,
  torch-audiomentations,
  torchaudio,
  torchmetrics,

  # optional-dependencies
  hydra-core,
  typer,
}:

buildPythonPackage rec {
  pname = "pyannote-audio";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-audio";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-NnwJJasObePBYWBnuVzOLFz2eqOHoOA6W5CzAEpkDV4=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "pyscaffold>=3.2a0,<3.3a0" "pyscaffold"
    substituteInPlace requirements.txt \
      --replace-fail "lightning" "pytorch-lightning"
  '';

  build-system = [
    pyscaffold
    setuptools
  ];

  pythonRelaxDeps = [
    "torchaudio"
  ];
  dependencies = [
    asteroid-filterbanks
    einops
    huggingface-hub
    numpy
    omegaconf
    pyannote-core
    pyannote-database
    pyannote-metrics
    pyannote-pipeline
    pytorch-lightning
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
  ];

  optional-dependencies = {
    cli = [
      hydra-core
      typer
    ];
  };

  pythonImportsCheck = [ "pyannote.audio" ];

  meta = {
    description = "Neural building blocks for speaker diarization: speech activity detection, speaker change detection, overlapped speech detection, speaker embedding";
    homepage = "https://github.com/pyannote/pyannote-audio";
    changelog = "https://github.com/pyannote/pyannote-audio/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
