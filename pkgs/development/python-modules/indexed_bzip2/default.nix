{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "indexed_bzip2";
  version = "1.1.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dxj0lsssi3p59dcl7aslr160r4kyll309m9hky33gl7gnjly0bw";
  };

  meta = with lib; {
    description = "Python library to seek within compressed bzip2 files";
    homepage = "https://github.com/mxmlnkn/indexed_bzip2";
    license = licenses.mit;
  };
}
