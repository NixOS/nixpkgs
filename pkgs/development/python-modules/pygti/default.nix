{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  aiohttp,
  pydantic,
  pytz,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygti";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "pygti";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B+jz91xoN7GiU4PnJTG5Kt1eA4ST63d+ZEgRrr9Xio8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    pydantic
    pytz
    voluptuous
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pygti.auth"
    "pygti.exceptions"
    "pygti.gti"
  ];

  meta = {
    changelog = "https://github.com/vigonotion/pygti/releases/tag/${finalAttrs.src.tag}";
    description = "Access public transport information in Hamburg, Germany";
    homepage = "https://github.com/vigonotion/pygti";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
