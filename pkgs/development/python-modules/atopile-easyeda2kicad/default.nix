{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pydantic,
  requests,
}:

buildPythonPackage rec {
  pname = "atopile-easyeda2kicad";
  version = "0.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "easyeda2kicad.py";
    tag = "v${version}";
    hash = "sha256-0d7lcs/aWSwxGBEIGkEcKc7SwBCqjBdoJIlCnLh8RFA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pydantic
    requests
  ];

  pythonImportsCheck = [ "easyeda2kicad" ];

  doCheck = false; # no tests

  meta = {
    description = "Convert any LCSC components (including EasyEDA) to KiCad library";
    homepage = "https://github.com/atopile/easyeda2kicad.py";
    changelog = "https://github.com/atopile/easyeda2kicad.py/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "easyeda2kicad";
  };
}
