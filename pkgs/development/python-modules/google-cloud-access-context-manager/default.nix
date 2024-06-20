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
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pbQkMSwISwK2+Ywev7avKBMvwB5dcZgX+kmeeMh+BLc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
