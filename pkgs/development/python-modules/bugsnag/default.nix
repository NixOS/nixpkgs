{ stdenv
, buildPythonPackage
, fetchPypi
, six
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b4c2e2e0ab8b74328d187441ad02973a52a3e1d31beaffbc972788801dd8874";
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
