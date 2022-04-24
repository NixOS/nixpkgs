{ lib, buildPythonPackage, fetchPypi, pythonAtLeast, sqlcipher }:

buildPythonPackage rec {
  pname = "pysqlcipher3";
  version = "1.0.4";

  disabled = pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75d6b9d023d7ab76c841f97fd9d108d87516e281268e61518411d08cb7062663";
  };

  buildInputs = [ sqlcipher ];

  pythonImportsCheck = [ "pysqlcipher3" ];

  meta = with lib; {
    description = "Python 3 bindings for SQLCipher";
    homepage = "https://github.com/rigglemania/pysqlcipher3/";
    license = licenses.zlib;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
