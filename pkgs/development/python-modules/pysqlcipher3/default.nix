{ lib, buildPythonPackage, fetchPypi, pythonOlder, sqlcipher }:

buildPythonPackage rec {
  pname = "pysqlcipher3";
  version = "1.2.0";

  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PIAzgSZVlH6/KagJrFEGsrxpvgJ06szva1j0WAyNBsU=";
  };

  buildInputs = [ sqlcipher ];

  pythonImportsCheck = [ "pysqlcipher3" ];

  meta = with lib; {
    description = "Python 3 bindings for SQLCipher";
    homepage = "https://github.com/rigglemania/pysqlcipher3/";
    license = licenses.zlib;
    maintainers = with maintainers; [ ];
  };
}
