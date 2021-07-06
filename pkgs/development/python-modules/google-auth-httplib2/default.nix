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
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac";
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
