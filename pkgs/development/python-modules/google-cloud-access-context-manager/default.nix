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
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_access_context_manager";
    inherit version;
    hash = "sha256-O/rGqO4ub5UQWo7s9OGJCxp5Y3AuuMZV/s8CVX00joo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  # No tests in repo
  doCheck = false;

  pythonImportsCheck = [ "google.identity.accesscontextmanager" ];

  meta = with lib; {
    description = "Protobufs for Google Access Context Manager";
    homepage = "https://github.com/googleapis/python-access-context-manager";
    changelog = "https://github.com/googleapis/python-access-context-manager/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
