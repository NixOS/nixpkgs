{
  buildPythonPackage,
  fetchFromGitHub,
  google-api-core,
  google-auth,
  lib,
  proto-plus,
  protobuf,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-geo-type";
  version = "3.30.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-asset-v${version}";
    hash = "sha256-4Ifg9igzsVR8pWH/lcrGwCnByqYQjPKChNPJGmmQbKI=";
  };

  sourceRoot = "${src.name}/packages/google-geo-type";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  pythonImportsCheck = [ "google.geo.type" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/google-geo-type/CHANGELOG.md";
    description = "Google Geo Type API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-geo-type";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
