{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pythonOlder
}:

if !(pythonOlder "3.3") then null else buildPythonPackage rec {
  pname = "backports.functools_lru_cache";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d98697f088eb1b0fa451391f91afb5e3ebde16bbdb272819fd091151fda4f1a";
  };

  buildInputs = [ setuptools_scm ];
  doCheck = false; # No proper test

  meta = {
    description = "Backport of functools.lru_cache";
    homepage = https://github.com/jaraco/backports.functools_lru_cache;
    license = lib.licenses.mit;
  };
}