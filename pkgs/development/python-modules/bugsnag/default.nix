{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "4.1.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdbdb3e02ef0c0655bb55be8b05ec1cb830b5ec629923ccb24bfd71dede3d1c3";
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
