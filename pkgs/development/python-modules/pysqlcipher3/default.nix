{ lib, buildPythonPackage, fetchPypi, pythonAtLeast, sqlcipher }:

buildPythonPackage rec {
  pname = "pysqlcipher3";
  version = "1.0.3";

  disabled = pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c54m18h52llwkfc9zaag3qkmfzzp5a1w9jzsm5hd2nfdsxmnkk9";
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
