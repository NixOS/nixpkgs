{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "oauth";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pdgi35hczsslil4890xqawnbpdazkgf2v1443847h5hy2gq2sg7";
  };

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/oauth/";
    description = "Library for OAuth version 1.0a";
    license = licenses.mit;
  };
}
