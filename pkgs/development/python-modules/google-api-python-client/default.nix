{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-auth,
  google-auth-httplib2,
  google-api-core,
  httplib2,
  uritemplate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "2.166.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_api_python_client";
    inherit version;
    hash = "sha256-uM+EO9nXNsE0rvds8dx6R8koOi7yQme5cge53UOzDvc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-auth
    google-auth-httplib2
    google-api-core
    httplib2
    uritemplate
  ];

  # No tests included in archive
  doCheck = false;

  pythonImportsCheck = [ "googleapiclient" ];

  meta = {
    description = "Official Python client library for Google's discovery based APIs";
    longDescription = ''
      These client libraries are officially supported by Google. However, the
      libraries are considered complete and are in maintenance mode. This means
      that we will address critical bugs and security issues but will not add
      any new features.
    '';
    homepage = "https://github.com/google/google-api-python-client";
    changelog = "https://github.com/googleapis/google-api-python-client/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
