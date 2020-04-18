{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
, webob
}:

buildPythonPackage rec {
  pname = "repoze.who";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b95dadc1242acc55950115a629cfb1352669774b46d22def51400ca683efea28";
  };

  propagatedBuildInputs = [ zope_interface webob ];

  meta = with stdenv.lib; {
    description = "WSGI Authentication Middleware / API";
    homepage = "http://www.repoze.org";
    license = licenses.bsd0;
  };

}
