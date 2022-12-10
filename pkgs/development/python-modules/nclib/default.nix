{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nclib";
  version = "1.0.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rA8oeYvMhw8HURxPLBRqpMHnAez/xBjyPFoKXIIvBjg=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "nclib" ];

  meta = with lib; {
    description = "Python module that provides netcat features";
    homepage = "https://nclib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
