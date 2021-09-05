{ lib, buildPythonPackage, fetchPypi
, setuptools-scm
, more-itertools, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfcf7da71e2a0e980189b0744b59dba6c1dcf66dcd7a30f8a4413e478046b314";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ more-itertools backports_functools_lru_cache ];

  doCheck = false;

  pythonNamespaces = [ "jaraco" ];

  meta = with lib; {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = "https://github.com/jaraco/jaraco.functools";
    license = licenses.mit;
  };
}
