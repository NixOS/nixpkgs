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
    sha256 = "0fdwnx2yd65f5vhnmn39f4xnxac5j6x0pv2p42qifrdi1z32q2cd";
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
