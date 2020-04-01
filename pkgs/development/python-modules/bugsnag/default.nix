{ stdenv
, buildPythonPackage
, fetchPypi
, six
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17cjh7g8gbr0gb22nzybkw7vq9x5wfa5ln94hhzijbz934bw1f37";
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
