{ lib
, aiohttp
, buildPythonPackage
, cryptography
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymazda";
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d51619cfbd90f4bb4e8fbfe1bccd58d4f5ece9bdb78d8f33fed1776d749d5fa9";
  };

  propagatedBuildInputs = [
    aiohttp
    cryptography
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pymazda"
  ];

  meta = with lib; {
    description = "Python client for interacting with the MyMazda API";
    homepage = "https://github.com/bdr99/pymazda";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
