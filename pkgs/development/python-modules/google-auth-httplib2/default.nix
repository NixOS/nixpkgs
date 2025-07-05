{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
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
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-auth-library-python-httplib2";
    tag = "v${version}";
    sha256 = "sha256-qY00u1srwAw68VXewZDOsWZrtHpi5UoRZfesSY7mTk8=";
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

  meta = {
    description = "Google Authentication Library: httplib2 transport";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
    changelog = "https://github.com/googleapis/google-auth-library-python-httplib2/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
