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
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s9v8ek0Louxu82oYhJO5xL5fkzHxOQ6dM6HCpCLwCZ8=";
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
