{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  fake-useragent,
  httpx,
  pydantic,
  truststore,
}:

buildPythonPackage (finalAttrs: {
  pname = "atopile-easyeda2kicad";
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "easyeda2kicad.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-63y8bbb5x0QatCB1z0WYjqis3FA45Q2DRtkXOnBvhqc=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    fake-useragent
    httpx
    pydantic
    truststore
  ];

  pythonImportsCheck = [ "easyeda2kicad" ];

  doCheck = false; # no tests

  meta = {
    description = "Convert any LCSC components (including EasyEDA) to KiCad library";
    homepage = "https://github.com/atopile/easyeda2kicad.py";
    changelog = "https://github.com/atopile/easyeda2kicad.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "easyeda2kicad";
  };
})
