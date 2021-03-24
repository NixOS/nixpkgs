{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pycryptodome
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymazda";
  version = "0.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "174c58e6e78081af3105524074ae26e62be683389e495ab85a30e2adbf7ba365";
  };

  propagatedBuildInputs = [ aiohttp pycryptodome ];

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
