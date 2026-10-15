{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wyoming-faster-whisper";
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "wyoming-faster-whisper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ciWOlcfYoA1/njH0k7oxgiJZYxRJpbAk6leWW9MFpg4=";
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
    pysilero-vad
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
    qwen3_asr = [
      onnxruntime
      tokenizers
    ];
    hass = [ aiohttp ];
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
    changelog = "https://github.com/OHF-Voice/wyoming-faster-whisper/releases/tag/v${finalAttrs.version}";
    description = "Wyoming Server for Faster Whisper";
    homepage = "https://github.com/OHF-Voice/wyoming-faster-whisper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "wyoming-faster-whisper";
  };
})
