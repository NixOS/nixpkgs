{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  protobuf,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_access_context_manager";
    inherit version;
    hash = "sha256-86o1ySJbeq74Xs2s7cwVd3ib6NRYt6QbatI7UEeG5fk=";
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

  meta = {
    description = "Protobufs for Google Access Context Manager";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-access-context-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-access-context-manager-v${version}/packages/google-cloud-access-context-manager/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ austinbutler ];
  };
}
