{ lib
, isPy3k
, buildPythonPackage
, fetchPypi
, flask
, mock
, six
, pytest
, pytest-localserver
, google_auth
, httplib2

}:

buildPythonPackage rec {
  pname = "google-auth-httplib2";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "098fade613c25b4527b2c08fa42d11f3c2037dda8995d86de0745228e965d445";
  };

  checkInputs = [
    flask mock six pytest pytest-localserver
  ];

  propagatedBuildInputs = [
    google_auth httplib2
  ];

  checkPhase = ''
    py.test
  '';

  # ImportError: No module named google.auth
  doCheck = isPy3k;

  meta = {
    description = "Google Authentication Library: httplib2 transport";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
    license = lib.licenses.asl20;
  };

}
