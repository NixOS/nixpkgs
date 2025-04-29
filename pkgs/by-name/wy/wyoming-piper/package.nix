{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-piper";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-piper";
    tag = "v${version}";
    hash = "sha256-HxLs2NH5muYzVfOtfLlV09BQ3waIfZKBCTiK/Tha6r4=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "wyoming"
  ];

  dependencies = with python3Packages; [
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_piper"
  ];

  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming-piper/blob/v${version}/CHANGELOG.md";
    description = "Wyoming Server for Piper";
    mainProgram = "wyoming-piper";
    homepage = "https://github.com/rhasspy/wyoming-piper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
