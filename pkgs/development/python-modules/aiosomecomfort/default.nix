{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, prettytable
}:

buildPythonPackage rec {
  pname = "aiosomecomfort";
  version = "0.0.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOSomecomfort";
    rev = "refs/tags/${version}";
    hash = "sha256-NVtoQJOC4rNny95/lFk2eJ5mycNSuZrIy1GGZKYZ1VA=";
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
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
