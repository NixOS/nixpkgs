{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  pythonOlder,
  protobuf,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_access_context_manager";
    inherit version;
    hash = "sha256-wt6A+6EZDkZ50zYmOE0Z4EpWujtNRh7VIeiSCa9jogk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  # No tests in repo
  doCheck = false;

  pythonImportsCheck = [ "google.identity.accesscontextmanager" ];

  meta = with lib; {
    description = "Protobufs for Google Access Context Manager";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-access-context-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-access-context-manager-v${version}/packages/google-cloud-access-context-manager/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
