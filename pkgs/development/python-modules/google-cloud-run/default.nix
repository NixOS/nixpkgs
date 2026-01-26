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

buildPythonPackage rec {
  pname = "google-cloud-run";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_run";
    inherit version;
    hash = "sha256-l1NK1206LCBH0STAoKKUpIIvzCQzHroPKUyt+xk8Sa0=";
  };

  build-system = [ setuptools ];

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
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-run-v${version}/packages/google-cloud-run/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
