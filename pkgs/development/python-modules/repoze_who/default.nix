{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
, webob
}:

buildPythonPackage rec {
  pname = "repoze.who";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12wsviar45nwn35w2y4i8b929dq2219vmwz8013wx7bpgkn2j9ij";
  };

  propagatedBuildInputs = [ zope_interface webob ];

  meta = with stdenv.lib; {
    description = "WSGI Authentication Middleware / API";
    homepage = "http://www.repoze.org";
    license = licenses.bsd0;
  };

}
