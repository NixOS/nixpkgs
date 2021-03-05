{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pycryptodome
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymazda";
  version = "0.0.9";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15kygabjlxmy3g5kj48ixqdwaz8qrfzxj8ii27cidsp2fq8ph165";
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
