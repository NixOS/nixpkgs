{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  asteroid-filterbanks,
  einops,
  huggingface-hub,
  lightning,
  matplotlib,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  opentelemetry-sdk,
  pyannote-core,
  pyannote-database,
  pyannote-metrics,
  pyannote-pipeline,
  pyannoteai-sdk,
  pytorch-metric-learning,
  safetensors,
  speechbrain,
  tensorboardx,
  torch,
  torch-audiomentations,
  torchaudio,
  torchcodec,
  torchmetrics,

  # optional-dependencies
  hydra-core,
  typer,

  # tests
  papermill,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyannote-audio";
  version = "4.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-audio";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-mns5ooODnJBTfFlM4b0GOoWqeTeD2CEhMikby6WdIM4=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonRelaxDeps = [
    "torch"
    "torchaudio"
    "torchcodec"
  ];
  dependencies = [
    asteroid-filterbanks
    einops
    huggingface-hub
    lightning
    matplotlib
    opentelemetry-api
    opentelemetry-exporter-otlp
    opentelemetry-sdk
    pyannote-core
    pyannote-database
    pyannote-metrics
    pyannote-pipeline
    pyannoteai-sdk
    pytorch-metric-learning
    safetensors
    speechbrain
    tensorboardx
    torch
    torch-audiomentations
    torchaudio
    torchcodec
    torchmetrics
  ];

  optional-dependencies = {
    cli = [
      hydra-core
      typer
    ];
  };

  pythonImportsCheck = [ "pyannote.audio" ];

  nativeCheckInputs = [
    papermill
    pytestCheckHook
  ];

  preCheck = ''
    $out/bin/pyannote-audio --help
  '';

  disabledTests = [
    # Require internet access
    "test_hf_download_inference"
    "test_hf_download_model"
    "test_import_speechbrain_encoder_classifier"
    "test_skip_aggregation"
    "test_unknown_specifications_error_raised_on_non_setup_model_task"

    # AttributeError: module 'torchaudio' has no attribute 'info'
    # Removed in torchaudio v2.9.0
    # See https://github.com/pytorch/audio/issues/3902 for context
    "test_audio_resample"
  ];

  disabledTestPaths =
    lib.optionals stdenv.hostPlatform.isDarwin [
      # Crashes the interpreter
      # - On aarch64-darwin: Trace/BPT trap: 5
      # - On x86_64-darwin: Fatal Python error: Illegal instruction
      "tests/inference_test.py"
      "tests/test_train.py"
    ]
    ++ lib.optionals (pythonAtLeast "3.14") [
      # RuntimeError: Please call `iter(combined_loader)` first.
      # https://github.com/Lightning-AI/pytorch-lightning/issues/20641
      "tests/inference_test.py"
      "tests/test_train.py"
      # PicklingError: Can't pickle <class 'pyannote.database.registry.Debug'>
      "tests/tasks/test_reproducibility.py"
    ];

  meta = {
    description = "Neural building blocks for speaker diarization: speech activity detection, speaker change detection, overlapped speech detection, speaker embedding";
    homepage = "https://github.com/pyannote/pyannote-audio";
    changelog = "https://github.com/pyannote/pyannote-audio/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
  };
})
