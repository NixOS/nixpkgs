{
  lib,
  aiohttp,
  aiortsp,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "reolink-aio";
  version = "0.9.10";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    rev = "refs/tags/${version}";
    hash = "sha256-wN2rWoRuxP5uLl2TkSnxlEwl29z6C8dDo9UkJ7amExo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiortsp
    orjson
    typing-extensions
  ];

  pythonImportsCheck = [ "reolink_aio" ];

  # All tests require a network device
  doCheck = false;

  meta = with lib; {
    description = "Module to interact with the Reolink IP camera API";
    homepage = "https://github.com/starkillerOG/reolink_aio";
    changelog = "https://github.com/starkillerOG/reolink_aio/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
