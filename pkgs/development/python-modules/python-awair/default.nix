{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, voluptuous
, vcrpy
}:

buildPythonPackage rec {
  pname = "python-awair";
  version = "0.2.2";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ahayworth";
    repo = "python_awair";
    rev = version;
    sha256 = "sha256-5+s1aSvt+rXyumvf/qZ58Uvmq0p45mu23Djbwgih3qI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [ "python_awair" ];

  meta = with lib; {
    description = "Python library for the Awair API";
    homepage = "https://github.com/ahayworth/python_awair";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
