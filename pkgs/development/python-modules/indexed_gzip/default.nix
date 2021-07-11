{ lib
, buildPythonPackage
, fetchPypi
, pkgs
, cython
, pytest-runner
, numpy
}:

buildPythonPackage rec {
  pname = "indexed_gzip";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08v3j34vii2ad8v2clrw63dxyqxkccfaxfdv5qwbq5bny1dxrc7x";
  };

  buildInputs = [ cython pkgs.zlib ];

  checkInputs = [ cython pytest-runner numpy ];

  doCheck = false; # unclear cause of errors

  meta = with lib; {
    description = "Python library to seek within compressed gzip files";
    homepage = "https://github.com/pauldmccarthy/indexed_gzip";
    license = licenses.zlib;
  };
}
