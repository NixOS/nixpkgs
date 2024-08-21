{
  lib,
  aiohttp,
  bluetooth-data-tools,
  buildPythonPackage,
  fetchFromGitHub,
  habluetooth,
  orjson,
  pythonOlder,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aioshelly";
  version = "11.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioshelly";
    rev = "refs/tags/${version}";
    hash = "sha256-+h7xRKTI5S+NQ0IdC2DJywQRIWUUd1mHti6K7VPhBAc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bluetooth-data-tools
    habluetooth
    orjson
    yarl
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "aioshelly" ];

  meta = with lib; {
    description = "Python library to control Shelly";
    homepage = "https://github.com/home-assistant-libs/aioshelly";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
