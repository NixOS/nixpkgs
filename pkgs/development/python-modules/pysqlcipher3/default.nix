{ lib, buildPythonPackage, fetchPypi, pythonOlder, sqlcipher }:

buildPythonPackage rec {
  pname = "pysqlcipher3";
  version = "1.1.0";

  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Lo75+2y2jZJrQZj9xrJvVRGWmOo8fI5iXzEURn00Y3E=";
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
