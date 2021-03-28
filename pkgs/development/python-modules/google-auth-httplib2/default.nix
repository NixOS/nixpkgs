{ lib
, isPy3k
, buildPythonPackage
, fetchPypi
, flask
, google-auth
, httplib2
, mock
, pytestCheckHook
, pytest-localserver
}:

buildPythonPackage rec {
  pname = "google-auth-httplib2";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fdwnx2yd65f5vhnmn39f4xnxac5j6x0pv2p42qifrdi1z32q2cd";
  };

  propagatedBuildInputs = [
    google-auth
    httplib2
  ];

  checkInputs = [
    flask
    mock
    pytestCheckHook
    pytest-localserver
  ];

  meta = with lib; {
    description = "Google Authentication Library: httplib2 transport";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
