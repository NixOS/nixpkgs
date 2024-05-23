{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  asteroid-filterbanks,
  einops,
  huggingface-hub,
  pytorch-lightning,
  omegaconf,
  pyannote-core,
  pyannote-database,
  pyannote-metrics,
  pyannote-pipeline,
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
  numpy,
  pyscaffold,
}:

buildPythonPackage rec {
  pname = "pyannote-audio";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-audio";
    rev = version;
    hash = "sha256-BxmEJE6v+QkEaAJ2oB2LwDQIoRajv6F9SRc8lP9iRLM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pyscaffold
    setuptools
    wheel
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pyscaffold>=3.2a0,<3.3a0" "pyscaffold"
    substituteInPlace requirements.txt \
      --replace "lightning" "pytorch-lightning"
  '';

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "pyannote.audio" ];

  meta = with lib; {
    description = "Neural building blocks for speaker diarization: speech activity detection, speaker change detection, overlapped speech detection, speaker embedding";
    homepage = "https://github.com/pyannote/pyannote-audio";
    changelog = "https://github.com/pyannote/pyannote-audio/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
