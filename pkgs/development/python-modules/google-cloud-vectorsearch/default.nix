{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  google-api-core,
  google-auth,
  grpcio,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-vectorsearch";
  version = "0.11.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "google_cloud_vectorsearch";
    inherit (finalAttrs) version;
    hash = "sha256-cHkmOucCEio/2GX6q6thoQM5eGhDx1UG7o6flZMxYkQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    grpcio
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    # don't import the source directory for testing
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.vectorsearch_v1"
    "google.cloud.vectorsearch_v1beta"
  ];

  meta = {
    description = "Google Cloud Vectorsearch API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-vectorsearch";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaravrav ];
  };
})
