{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "life360";
  version = "5.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pnbruckner";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-F/j3qIdz63pEQ+nj1poP3lBFWSpSq4nLseYg+N2tykU=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "life360"
  ];

  meta = with lib; {
    description = "Python module to interact with Life360";
    homepage = "https://github.com/pnbruckner/life360";
    changelog = "https://github.com/pnbruckner/life360/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
