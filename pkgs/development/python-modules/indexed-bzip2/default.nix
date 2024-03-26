{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "indexed_bzip2";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3HUiigZR91/nbOAMOuSHGcPtqkkEaj3VepyMhmKOHpI=";
  };

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "indexed_bzip2" ];

  meta = with lib; {
    description = "Python library for parallel decompression and seeking within compressed bzip2 files";
    mainProgram = "ibzip2";
    homepage = "https://github.com/mxmlnkn/indexed_bzip2";
    license = licenses.mit; # dual MIT and asl20, https://internals.rust-lang.org/t/rationale-of-apache-dual-licensing/8952
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = platforms.all;
  };
}
