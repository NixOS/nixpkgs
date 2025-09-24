{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-piper";
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-piper";
    tag = "v${version}";
    hash = "sha256-Opnv4PtLZpG2kBAuJ8xWsQpJ2y9G9zYFsHQm7nwjUKk=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "regex"
    "wyoming"
  ];

  dependencies = with python3Packages; [
    regex
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_piper"
  ];

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

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming-piper/blob/${src.tag}/CHANGELOG.md";
    description = "Wyoming Server for Piper";
    mainProgram = "wyoming-piper";
    homepage = "https://github.com/rhasspy/wyoming-piper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
