{
  lib,
  buildPythonPackage,
  fetchPypi,
  googleapis-common-protos,
  protobuf,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-audit-log";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_audit_log";
    inherit version;
    hash = "sha256-kBQoslcCDYwdETPg+gBBZKVV5aOVx8o827hIZRPfOmU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    googleapis-common-protos
    protobuf
  ];

  # Tests are a bit wonky to setup and are not very deep either
  doCheck = false;

  pythonImportsCheck = [ "google.cloud.audit" ];

  meta = with lib; {
    description = "Google Cloud Audit Protos";
    homepage = "https://github.com/googleapis/python-audit-log";
    changelog = "https://github.com/googleapis/python-audit-log/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
