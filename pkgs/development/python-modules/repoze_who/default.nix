{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, webob
}:

buildPythonPackage rec {
  pname = "repoze.who";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6VWt8AwfCwxxXoKJeaI37Ev37nCCe9l/Xhe/gnYNyzA=";
  };

  propagatedBuildInputs = [ zope_interface webob ];

  meta = with lib; {
    description = "WSGI Authentication Middleware / API";
    homepage = "http://www.repoze.org";
    license = licenses.bsd0;
  };

}
