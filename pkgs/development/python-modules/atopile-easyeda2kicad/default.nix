{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  httpx,
  pydantic,
  truststore,
}:

buildPythonPackage rec {
  pname = "atopile-easyeda2kicad";
  version = "0.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "easyeda2kicad.py";
    tag = "v${version}";
    hash = "sha256-l5ecNNu9vu073aK85F+tOSodEHk2wso95RYXk9DyTFo=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    httpx
    pydantic
    truststore
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
