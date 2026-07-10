{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wyoming-faster-whisper";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-faster-whisper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4tgBsraFd7IUHw6p/59FHzuUISOaALxBU7H8V0yQl0E=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "faster-whisper"
    "wyoming"
  ];

  dependencies = with python3Packages; [
    faster-whisper
    wyoming
  ];

  optional-dependencies = with python3Packages; {
    transformers = [
      transformers
    ]
    ++ transformers.optional-dependencies.torch;
    sherpa = [
      sherpa-onnx
    ];
    onnx_asr = [
      onnx-asr
    ]
    ++ onnx-asr.optional-dependencies.cpu
    ++ onnx-asr.optional-dependencies.hub;
    zeroconf = [
      wyoming
    ]
    ++ wyoming.optional-dependencies.zeroconf;
  };

  pythonImportsCheck = [
    "wyoming_faster_whisper"
  ];

  # tests require models from huggingface
  doCheck = false;

  meta = {
    changelog = "https://github.com/rhasspy/wyoming-faster-whisper/releases/tag/v${finalAttrs.version}";
    description = "Wyoming Server for Faster Whisper";
    homepage = "https://github.com/rhasspy/wyoming-faster-whisper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "wyoming-faster-whisper";
  };
})
