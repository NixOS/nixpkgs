{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "offtrac";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ptC9aW5nxqsTUEuLKeSfJDv3cQRD2SCdp+cHdUEAbRs=";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "http://fedorahosted.org/offtrac";
    description = "Trac xmlrpc library";
    license = licenses.gpl2;
  };
}
