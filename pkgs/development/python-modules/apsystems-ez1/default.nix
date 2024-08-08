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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SonnenladenGmbH";
    repo = "APsystems-EZ1-API";
    rev = "refs/tags/${version}";
    hash = "sha256-cxX0iwNqx8uj0ZlqjuvyRfI+5QkFeLL+M529ACc2rDk=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "APsystemsEZ1" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = {
    changelog = "https://github.com/SonnenladenGmbH/APsystems-EZ1-API/releases/tag/${version}";
    description = "Streamlined interface for interacting with the local API of APsystems EZ1 Microinverters.";
    homepage = "https://github.com/SonnenladenGmbH/APsystems-EZ1-API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
