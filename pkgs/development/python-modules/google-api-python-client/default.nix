{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-auth,
  google-auth-httplib2,
  google-api-core,
  httplib2,
  uritemplate,
  oauth2client,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "2.133.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KTCSkFtmoEbTGHqZrEVOErAMwscERPJusvH5wagnILQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-auth
    google-auth-httplib2
    google-api-core
    httplib2
    uritemplate
    oauth2client
  ];

  # No tests included in archive
  doCheck = false;

  pythonImportsCheck = [ "googleapiclient" ];

  meta = with lib; {
    description = "Official Python client library for Google's discovery based APIs";
    longDescription = ''
      These client libraries are officially supported by Google. However, the
      libraries are considered complete and are in maintenance mode. This means
      that we will address critical bugs and security issues but will not add
      any new features.
    '';
    homepage = "https://github.com/google/google-api-python-client";
    changelog = "https://github.com/googleapis/google-api-python-client/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
