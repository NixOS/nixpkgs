{
  lib,
  buildPythonPackage,
  fetchPypi,
  googleapis-common-protos,
  protobuf,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-audit-log";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_audit_log";
    inherit version;
    hash = "sha256-zKeB4fG1SY3xgyoLaDqZ6GwAsxAVu77vMAI4H3qWpj8=";
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
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-audit-log";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-audit-log-v${version}/packages/google-cloud-audit-log/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
