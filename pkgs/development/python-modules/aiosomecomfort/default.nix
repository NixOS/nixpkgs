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
  version = "0.0.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOSomecomfort";
    tag = version;
    hash = "sha256-AsYq5ElfHtUoEEI5TMIs0wf5yMK1ZKCteWYfTon+Wik=";
  };

  build-system = [
    setuptools
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
