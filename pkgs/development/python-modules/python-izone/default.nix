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

buildPythonPackage rec {
  pname = "python-izone";
  version = "1.3.10";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    tag = "v${version}";
    hash = "sha256-X5yH3mzevCq4hO1IikfcvXmk9rTfL3jiMaf7mACZ+k0=";
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
}
