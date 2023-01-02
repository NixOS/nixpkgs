{ lib
, buildPythonPackage
, fetchPypi
, flask
, google-auth
, httplib2
, mock
, pytest-localserver
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-auth-httplib2";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oHw5/WMr7KzT8HcY39YCG/OWl48DrTzkMh0GABXMMKw=";
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
    changelog = "https://github.com/googleapis/google-auth-library-python-httplib2/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
