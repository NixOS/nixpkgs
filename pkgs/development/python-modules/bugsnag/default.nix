{ stdenv
, buildPythonPackage
, fetchPypi
, six
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32966bfe625ec6fc0dbc9d86d79a18f31b22b2fdec3ca070eeb3495304f7e18d";
  };

  propagatedBuildInputs = [ six webob ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Automatic error monitoring for django, flask, etc.";
    homepage = "https://www.bugsnag.com";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
