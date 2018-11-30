{ lib, buildPythonPackage, fetchPypi
, setuptools_scm
, more-itertools, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "1.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bad775f06e58bb8de5563bc2a8bf704168919e6779d6e849b1ca58b443e97f3b";
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
