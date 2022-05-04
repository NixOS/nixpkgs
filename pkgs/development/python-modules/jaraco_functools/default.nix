{ lib, buildPythonPackage, fetchPypi
, setuptools-scm
, more-itertools, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31e0e93d1027592b7b0bec6ad468db850338981ebee76ba5e212e235f4c7dda0";
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
