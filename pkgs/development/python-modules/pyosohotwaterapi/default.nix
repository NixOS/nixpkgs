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
  pname = "pyosohotwaterapi";
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

  pythonImportsCheck = [ "apyosoenergyapi" ];

  meta = with lib; {
    description = "Module for using the OSO Hotwater API";
    homepage = "https://github.com/osohotwateriot/apyosohotwaterapi";
    changelog = "https://github.com/osohotwateriot/apyosohotwaterapi/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
