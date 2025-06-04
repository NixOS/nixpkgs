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
}:

buildPythonPackage rec {
  pname = "google-auth-httplib2";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OKp7rfSPl08euYYXlOnAyyoFEaTsBnmx+IbRCPVkDgU=";
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

  meta = {
    description = "Google Authentication Library: httplib2 transport";
    longDescription = ''
      The library was created to help clients migrate from oauth2client to google-auth,
      however this library is no longer maintained. For any new usages please see
      provided transport layers by google-auth library
    '';
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
    changelog = "https://github.com/googleapis/google-auth-library-python-httplib2/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
