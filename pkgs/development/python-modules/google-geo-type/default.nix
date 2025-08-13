{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
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
  version = "0.3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-geo-type-v${version}";
    hash = "sha256-VYkgkVrUgBiUEFF2J8ZFrh2Sw7h653stYxNcpYfRAj4=";
  };

  sourceRoot = "${src.name}/packages/google-geo-type";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  pythonImportsCheck = [ "google.geo.type" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "google-geo-type-v"; };

  meta = {
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/google-geo-type/CHANGELOG.md";
    description = "Google Geo Type API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-geo-type";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
