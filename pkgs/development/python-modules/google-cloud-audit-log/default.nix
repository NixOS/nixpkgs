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
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_audit_log";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-hGfU3MqfPmFgUgwk1xWS5J6HSDjxdHYicuwQ55ULb+s=";
=======
    hash = "sha256-zKeB4fG1SY3xgyoLaDqZ6GwAsxAVu77vMAI4H3qWpj8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    googleapis-common-protos
    protobuf
  ];

  # Tests are a bit wonky to setup and are not very deep either
  doCheck = false;

  pythonImportsCheck = [ "google.cloud.audit" ];

<<<<<<< HEAD
  meta = {
    description = "Google Cloud Audit Protos";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-audit-log";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-audit-log-v${version}/packages/google-cloud-audit-log/CHANGELOG.md";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Google Cloud Audit Protos";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-audit-log";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-audit-log-v${version}/packages/google-cloud-audit-log/CHANGELOG.md";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
