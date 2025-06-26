{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-piper";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-piper";
    tag = "v${version}";
    hash = "sha256-r7odRraBSDP2fbRJ3ixaL80fhBSb9r5icPuf1Qa6Va8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
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
