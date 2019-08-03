{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, isPy3k
, pytest
}:

buildPythonPackage rec {
  pname = "backports.functools_lru_cache";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d98697f088eb1b0fa451391f91afb5e3ebde16bbdb272819fd091151fda4f1a";
  };

  buildInputs = [ setuptools_scm ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  # Test fail on Python 2
  doCheck = isPy3k;

  meta = {
    description = "Backport of functools.lru_cache";
    homepage = https://github.com/jaraco/backports.functools_lru_cache;
    license = lib.licenses.mit;
  };
}