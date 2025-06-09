{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  aiohttp,
  poetry-core,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "apsystems-ez1";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SonnenladenGmbH";
    repo = "APsystems-EZ1-API";
    tag = version;
    hash = "sha256-/dseMzi92qlual+L6v6Cl5Xd4U9c7SPdclmTSQTVor0=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "APsystemsEZ1" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = {
    changelog = "https://github.com/SonnenladenGmbH/APsystems-EZ1-API/releases/tag/${src.tag}";
    description = "Streamlined interface for interacting with the local API of APsystems EZ1 Microinverters.";
    homepage = "https://github.com/SonnenladenGmbH/APsystems-EZ1-API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
