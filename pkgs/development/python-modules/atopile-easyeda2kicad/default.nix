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
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "easyeda2kicad.py";
    tag = "v${version}";
    hash = "sha256-TLGLNe/Lk2WpYMzmX2iK3S27/QRqTOdHqO8XIMZSda4=";
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
    changelog = "https://github.com/atopile/easyeda2kicad.py/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "easyeda2kicad";
  };
}
