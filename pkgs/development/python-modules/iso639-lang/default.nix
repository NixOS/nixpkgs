{
  fetchFromGitHub,
  lib,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "iso639-lang";
  version = "2.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LBeaudoux";
    repo = "iso639";
    rev = "v${version}";
    hash = "sha256-ORqSrf84b/ddpCUi9e43ur6C+XcJjQGM+fmJ8e/wFus=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonImportsCheck = [
    "iso639"
  ];

  meta = {
    description = "A fast, comprehensive, ISO 639 library";
    homepage = "https://github.com/LBeaudoux/iso639";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xelden ];
    mainProgram = "iso639";
  };
}
