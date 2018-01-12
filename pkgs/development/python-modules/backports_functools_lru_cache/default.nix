{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "backports.functools_lru_cache";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31f235852f88edc1558d428d890663c49eb4514ffec9f3650e7f3c9e4a12e36f";
  };

  buildInputs = [ setuptools_scm ];
  doCheck = false; # No proper test

  meta = {
    description = "Backport of functools.lru_cache";
    homepage = https://github.com/jaraco/backports.functools_lru_cache;
    license = lib.licenses.mit;
  };
}