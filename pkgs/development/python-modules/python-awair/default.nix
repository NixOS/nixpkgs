{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, voluptuous
, vcrpy
}:

buildPythonPackage rec {
  pname = "python-awair";
  version = "0.2.1";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ahayworth";
    repo = "python_awair";
    rev = version;
    sha256 = "1fqjigc1a0lr9q6bjjq3j8pa39wg1cbkb0l67w94a0i4dkdfri8r";
  };

  nativeBuildInputs = [ poetry ];

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
