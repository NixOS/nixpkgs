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
    hash = "sha256-52mBn/CwwEPQICRs4d78qt1lucIdJERopFp/BsuIr10=";
  };

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/oauth/";
    description = "Library for OAuth version 1.0a";
    license = licenses.mit;
  };
}
