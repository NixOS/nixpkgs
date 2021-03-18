{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pycryptodome
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymazda";
  version = "0.0.10";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sJj4RkVaELNitcz1H8YitNgIx4f35WeQf7M5miYD5yI=";
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
