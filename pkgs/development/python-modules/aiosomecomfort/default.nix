{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, prettytable
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aiosomecomfort";
  version = "0.0.22";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOSomecomfort";
    rev = "refs/tags/${version}";
    hash = "sha256-d4pyt9+sBPNo/PL05HQ4sjyjubMtTZI9WUGRU1B/dH0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    prettytable
  ];

  pythonImportsCheck = [
    "aiosomecomfort"
  ];

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
