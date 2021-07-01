{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "4.0.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b70bc95e4e4f98b2eef7a3dadfdc50c1a40da7f50446adf43be05574a4b9f7c";
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
