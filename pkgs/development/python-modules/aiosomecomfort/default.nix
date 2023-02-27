{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, prettytable
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosomecomfort";
  version = "0.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOSomecomfort";
    rev = "refs/tags/${version}";
    hash = "sha256-w9rD/8fb9CoN9esHY0UEjIs98i9OGp+suiz6I5Uj3ok=";
  };

  propagatedBuildInputs = [
    aiohttp
    prettytable
  ];

  pythonImportsCheck = [
    "aiosomecomfort"
  ];

  doCheck = false; # tests only run on windows, due to WindowsSelectorEventLoopPolicy

  meta = {
    description = "AsyicIO client for US models of Honeywell Thermostats";
    homepage = "https://github.com/mkmer/AIOSomecomfort";
    changelog = "https://github.com/mkmer/AIOSomecomfort/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
