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
  version = "1.1.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "osohotwateriot";
    repo = "apyosohotwaterapi";
    rev = "refs/tags/${version}";
    hash = "sha256-7FLGmmndrFqSl4oC8QFIYNlFJPr+xbiZG5ZRt4vx8+s=";
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
    changelog = "https://github.com/osohotwateriot/apyosohotwaterapi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
