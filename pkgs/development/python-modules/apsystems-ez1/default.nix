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
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SonnenladenGmbH";
    repo = "APsystems-EZ1-API";
    rev = "refs/tags/${version}";
    hash = "sha256-V6GcTSupjhjGEOsO+C9pImYJRnvdDbttW3Zh0PDYt5I=";
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
