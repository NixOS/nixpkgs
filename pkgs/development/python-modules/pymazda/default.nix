{ lib
, aiohttp
, buildPythonPackage
, cryptography
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymazda";
  version = "0.1.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vV7Morza6ov/rN44+7Rvo9p7DoE6jQtDk00TdrD0zBo=";
  };

  propagatedBuildInputs = [
    aiohttp
    cryptography
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pymazda" ];

  meta = with lib; {
    description = "Python client for interacting with the MyMazda API";
    homepage = "https://github.com/bdr99/pymazda";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
