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
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_audit_log";
    inherit version;
    hash = "sha256-OzLV5322NMRvvWxeAfW9qDb0IN+7IdcwUBx16fq05KQ=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    googleapis-common-protos
    protobuf
  ];

  # Tests are a bit wonky to setup and are not very deep either
  doCheck = false;

  pythonImportsCheck = [ "google.cloud.audit" ];

  meta = {
    description = "Google Cloud Audit Protos";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-audit-log";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-audit-log-v${version}/packages/google-cloud-audit-log/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
