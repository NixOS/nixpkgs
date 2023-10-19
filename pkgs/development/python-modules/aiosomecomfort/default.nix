{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, prettytable
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosomecomfort";
  version = "0.0.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOSomecomfort";
    rev = "refs/tags/${version}";
    hash = "sha256-HJbLsl1NHZxfH17mIi0T6h5ZSfKaw4VYbNgN6vmN7l4=";
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
