{
  lib,
  buildPythonPackage,
  fetchPypi,
  sqlcipher,
}:

buildPythonPackage rec {
  pname = "pysqlcipher3";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PIAzgSZVlH6/KagJrFEGsrxpvgJ06szva1j0WAyNBsU=";
  };

  buildInputs = [ sqlcipher ];

  pythonImportsCheck = [ "pysqlcipher3" ];

  meta = {
    description = "Python 3 bindings for SQLCipher";
    homepage = "https://github.com/rigglemania/pysqlcipher3/";
    license = lib.licenses.zlib;
    maintainers = [ ];
  };
}
