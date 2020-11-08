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
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d092cc60fb16517b12057ec0bba9185a96e3b7169d86ae12eae98e645b7bc39";
  };

  checkInputs = [
    flask mock six pytest pytest-localserver
  ];

  requiredPythonModules = [
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
