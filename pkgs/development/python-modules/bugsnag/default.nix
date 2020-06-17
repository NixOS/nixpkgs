{ stdenv
, buildPythonPackage
, fetchPypi
, six
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8878437aa44ec485cecb255742035b3b98a6c7e7d167a943b5fbe597b2f8f7f9";
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
