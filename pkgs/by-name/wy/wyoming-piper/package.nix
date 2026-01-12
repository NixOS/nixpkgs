{
  lib,
  python3Packages,
  piper-tts,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-piper";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-piper";
    tag = "v${version}";
    hash = "sha256-j6QvGChAkASKdD+4XqIwC6UWdhi5oMDfYmSk6kvRrNE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "regex"
    "sentence-stream"
    "wyoming"
  ];

  dependencies =
    with python3Packages;
    [
      regex
      piper-tts
      sentence-stream
      wyoming
    ]
    ++ wyoming.optional-dependencies.zeroconf;

  pythonImportsCheck = [
    "wyoming_piper"
  ];

  doCheck = false; # only test requires network

  nativeCheckInputs = with python3Packages; [
    numpy
    pytest-asyncio
    pytestCheckHook
    python-speech-features
  ];

  disabledTests = [
    # network access
    "test_piper"
  ];

  meta = {
    changelog = "https://github.com/rhasspy/wyoming-piper/blob/${src.rev}/CHANGELOG.md";
    description = "Wyoming Server for Piper";
    mainProgram = "wyoming-piper";
    homepage = "https://github.com/rhasspy/wyoming-piper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
