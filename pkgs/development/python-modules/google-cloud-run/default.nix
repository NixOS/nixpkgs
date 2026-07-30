{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-auth,
  grpc-google-iam-v1,
  grpcio,
  proto-plus,
  protobuf,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-run";
  version = "0.16.1";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_run";
    inherit (finalAttrs) version;
    hash = "sha256-Vov3/Ouo+ESjm2mFio5kL2zKJ+q3JGxiHZ00HCibEVg=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    google-api-core
    google-auth
    grpc-google-iam-v1
    grpcio
    proto-plus
    protobuf
  ];

  # Tests are only available in the google-cloud-python monorepo
  doCheck = false;

  pythonImportsCheck = [ "google.cloud.run" ];

  meta = {
    description = "Google Cloud Run API client library";
    homepage = "https://pypi.org/project/google-cloud-run/";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-run-v${finalAttrs.version}/packages/google-cloud-run/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
