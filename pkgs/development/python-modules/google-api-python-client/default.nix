{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-auth,
  google-auth-httplib2,
  google-api-core,
  httplib2,
  uritemplate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "2.169.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-api-python-client";
    tag = "v${version}";
    hash = "sha256-XJwZ/gWL2pO9P+HuN6BtVbacNjwbZV2jW6FVLgNsj/0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-auth
    google-auth-httplib2
    google-api-core
    httplib2
    uritemplate
  ];

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
