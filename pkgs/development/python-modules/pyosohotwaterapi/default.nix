{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  numpy,
  pythonOlder,
  setuptools,
  unasync,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pyosohotwaterapi";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "osohotwateriot";
    repo = "apyosohotwaterapi";
    tag = version;
    hash = "sha256-GFjA1RtJC2bxSoH2TIZwEdSAvpteYBTbsS81hhp4Y3E=";
  };

  # https://github.com/osohotwateriot/apyosohotwaterapi/pull/3
  pythonRemoveDeps = [ "pre-commit" ];

  build-system = [
    setuptools
    unasync
  ];

  dependencies = [
    aiohttp
    loguru
    numpy
    urllib3
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

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
