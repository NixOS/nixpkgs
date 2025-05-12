{
  buildPythonPackage,
  fetchFromGitHub,
  google-api-core,
  google-auth,
  google-geo-type,
  lib,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-maps-routing";
  version = "3.30.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-asset-v${version}";
    hash = "sha256-4Ifg9igzsVR8pWH/lcrGwCnByqYQjPKChNPJGmmQbKI=";
  };

  sourceRoot = "${src.name}/packages/google-maps-routing";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
    google-geo-type
  ] ++ google-api-core.optional-dependencies.grpc;

  pythonImportsCheck = [ "google.maps.routing_v2" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/google-maps-routing/CHANGELOG.md";
    description = "Google Maps Routing API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-maps-routing";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
