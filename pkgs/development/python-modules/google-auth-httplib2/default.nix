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
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xkvFVf3G3XiOpi7Pe8z/z0l793JEiHo/PXpaAvjj/Ck=";
  };

  propagatedBuildInputs = [
    google-auth
    httplib2
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
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
    maintainers = with maintainers; [ ];
  };
}
