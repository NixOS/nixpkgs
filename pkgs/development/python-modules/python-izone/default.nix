{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  ifaddr,
  pytest-aio,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-izone";
  version = "1.3.12";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G4Hx3gXIaASZ6SKC+q3Gowc/JKOmTVC0ACUy+DrZegg=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    ifaddr
  ];

  nativeCheckInputs = [
    pytest-aio
    pytest-asyncio
    pytestCheckHook
  ];

  doCheck = false; # most tests access network

  pythonImportsCheck = [ "pizone" ];

  meta = {
    description = "Python interface to the iZone airconditioner controller";
    homepage = "https://github.com/Swamp-Ig/pizone";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
