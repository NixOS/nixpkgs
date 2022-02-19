{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "4.2.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NnTn4m9we40Ww2abP7mbz1CtdypZyN2GYBvj8zxhOpI=";
  };

  propagatedBuildInputs = [ six webob ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Automatic error monitoring for django, flask, etc.";
    homepage = "https://www.bugsnag.com";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
