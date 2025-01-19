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
    sha256 = "06vd010pa1z7lyfj1na30iqzffr4kzj2k2sba09spik7drlvvl56";
  };

  doCheck = false;

  meta = {
    homepage = "http://fedorahosted.org/offtrac";
    description = "Trac xmlrpc library";
    license = lib.licenses.gpl2;
  };
}
