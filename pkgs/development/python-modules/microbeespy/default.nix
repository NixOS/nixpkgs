{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  paho-mqtt,
  setuptools,
}:

buildPythonPackage rec {
  pname = "microbeespy";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microBeesTech";
    repo = "pythonSDK";
    tag = version;
    hash = "sha256-h3IbWdZ/iHsNlAr/DfASj4dKNkQ4t1mUUeUIs00L8iU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    paho-mqtt
  ];

  # Package doesn't include tests
  doCheck = false;

  pythonImportsCheck = [ "microBeesPy" ];

  meta = {
    description = "Official microBees Python Library";
    homepage = "https://github.com/microBeesTech/pythonSDK";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
