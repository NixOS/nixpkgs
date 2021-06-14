{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, webob
}:

buildPythonPackage rec {
  pname = "repoze.who";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf97450de3c8eb5c03b4037be75b018db91befab1094204e452a0b1c0f7a94a6";
  };

  propagatedBuildInputs = [ zope_interface webob ];

  meta = with lib; {
    description = "WSGI Authentication Middleware / API";
    homepage = "http://www.repoze.org";
    license = licenses.bsd0;
  };

}
