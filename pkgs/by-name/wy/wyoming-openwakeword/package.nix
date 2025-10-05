{
  lib,
  python312Packages,
  fetchFromGitHub,
}:

let
  # tensorflow-bin unsupported on Python 3.13
  python3Packages = python312Packages;
in

python3Packages.buildPythonApplication rec {
  pname = "wyoming-openwakeword";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-openwakeword";
    rev = "refs/tags/v${version}";
    hash = "sha256-5suYJ+Z6ofVAysoCdHi5b5K0JTYaqeFZ32Cm76wC5LU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "wyoming"
  ];

  pythonRemoveDeps = [
    "tflite-runtime-nightly"
  ];

  dependencies = with python3Packages; [
    tensorflow-bin
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_openwakeword"
  ];

  meta = {
    changelog = "https://github.com/rhasspy/wyoming-openwakeword/blob/v${version}/CHANGELOG.md";
    description = "Open source voice assistant toolkit for many human languages";
    homepage = "https://github.com/rhasspy/wyoming-openwakeword";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "wyoming-openwakeword";
  };
}
