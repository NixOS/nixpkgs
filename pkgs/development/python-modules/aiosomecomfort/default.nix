{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  prettytable,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiosomecomfort";
  version = "0.0.25";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOSomecomfort";
    rev = "refs/tags/${version}";
    hash = "sha256-EmglZW9gzgswxoEtDT+evjn8N+3aPooYFudwAXP8XEE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
