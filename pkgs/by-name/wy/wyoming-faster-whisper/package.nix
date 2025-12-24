{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-faster-whisper";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-faster-whisper";
    rev = "refs/tags/v${version}";
    hash = "sha256-3/NXnb+huh3LdarFnVg4tTbs8P3JlDMdtrRn9nrsBOw=";
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
