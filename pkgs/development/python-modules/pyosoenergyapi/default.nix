{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  numpy,
  setuptools,
  unasync,
  urllib3,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pyosoenergyapi";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osohotwateriot";
    repo = "apyosohotwaterapi";
    tag = version;
    hash = "sha256-hpbmiSOLawKVSh7BGV70bRi45HCDKmdxEEhCOdJuIww=";
  };

  build-system = [
    setuptools
    unasync
    writableTmpDirAsHomeHook
  ];

  dependencies = [
    aiohttp
    loguru
    numpy
    urllib3
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyosoenergyapi" ];

  meta = {
    description = "Python library to interface with the OSO Energy API";
    homepage = "https://github.com/osohotwateriot/apyosohotwaterapi";
    changelog = "https://github.com/osohotwateriot/apyosohotwaterapi/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
