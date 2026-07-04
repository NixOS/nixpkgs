{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  prettytable,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiosomecomfort";
  version = "0.0.36";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOSomecomfort";
    tag = version;
    hash = "sha256-Da2Nvke01S7Pt+md2G5RRJqyUc6M3tcj4qsdSJVoQds=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiohttp"
  ];

  dependencies = [
    aiohttp
    prettytable
  ];

  pythonImportsCheck = [ "aiosomecomfort" ];

  # Tests only run on Windows, due to WindowsSelectorEventLoopPolicy
  doCheck = false;

  meta = {
    description = "AsyicIO client for US models of Honeywell Thermostats";
    homepage = "https://github.com/mkmer/AIOSomecomfort";
    changelog = "https://github.com/mkmer/AIOSomecomfort/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
