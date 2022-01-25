{ lib
, aiohttp
, buildPythonPackage
, cryptography
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymazda";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb4b275bcdfbf947e00b27c20dfc8ebcedfc1fb1252449141eccb5c39d782440";
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
