{ lib, buildPythonPackage, fetchPypi
, setuptools_scm
, more-itertools, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nhl0pjc7acxznhadg9wq1a6ls17ja2np8vf9psq8j66716mk2ya";
  };

  propagatedBuildInputs = [ more-itertools backports_functools_lru_cache ];

  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = with lib; {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = https://github.com/jaraco/jaraco.functools;
    license = licenses.mit;
  };
}
