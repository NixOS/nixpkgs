{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, webob
}:

buildPythonPackage rec {
  pname = "repoze.who";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ikybkmi0/w7dkG6Xwu7XzoPrn2LkJQv+A7zbum0xojc=";
  };

  propagatedBuildInputs = [ zope_interface webob ];

  meta = with lib; {
    description = "WSGI Authentication Middleware / API";
    homepage = "http://www.repoze.org";
    license = licenses.bsd0;
  };

}
