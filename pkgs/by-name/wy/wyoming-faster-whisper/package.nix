{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-faster-whisper";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-faster-whisper";
    rev = "refs/tags/v${version}";
    hash = "sha256-MKB6gZdGdAYoNK8SRiDHG8xtMZ5mXdaSn+bH4T6o/K4=";
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

  optional-dependencies = {
    transformers =
      with python3Packages;
      [
        transformers
      ]
      ++ transformers.optional-dependencies.torch;
  };

  pythonImportsCheck = [
    "wyoming_faster_whisper"
  ];

  # no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/rhasspy/wyoming-faster-whisper/releases/tag/v${version}";
    description = "Wyoming Server for Faster Whisper";
    homepage = "https://github.com/rhasspy/wyoming-faster-whisper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "wyoming-faster-whisper";
  };
}
