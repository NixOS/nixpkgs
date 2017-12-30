{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "backports.functools_lru_cache";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "444a21bcec4ae177da554321f81a78dc879eaa8f6ea9920cb904830585d31e95";
  };

  buildInputs = [ setuptools_scm ];
  doCheck = false; # No proper test

  meta = {
    description = "Backport of functools.lru_cache";
    homepage = https://github.com/jaraco/backports.functools_lru_cache;
    license = lib.licenses.mit;
  };
}