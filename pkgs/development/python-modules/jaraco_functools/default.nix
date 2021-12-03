{ lib, buildPythonPackage, fetchPypi
, setuptools-scm
, more-itertools, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "659a64743047d00c6ae2a2aa60573c62cfc0b4b70eaa14fa50c80360ada32aa8";
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
