{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  google-auth,
  httplib2,
  mock,
  pytest-localserver,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-auth-httplib2";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OKp7rfSPl08euYYXlOnAyyoFEaTsBnmx+IbRCPVkDgU=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  pythonImportsCheck = [ "google_auth_httplib2" ];

  meta = with lib; {
    description = "Google Authentication Library: httplib2 transport";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
    changelog = "https://github.com/googleapis/google-auth-library-python-httplib2/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
