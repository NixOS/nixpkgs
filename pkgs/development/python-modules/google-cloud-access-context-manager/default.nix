{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  protobuf,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-access-context-manager";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_access_context_manager";
    inherit (finalAttrs) version;
    hash = "sha256-lQzmWXMIWB4//TeP/TheoOFsCZzdVmkyhXzBDF53R1I=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

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
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-access-context-manager-v${finalAttrs.version}/packages/google-cloud-access-context-manager/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ austinbutler ];
  };
})
