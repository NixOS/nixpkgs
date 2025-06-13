{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  google-api-core,
  google-auth,
  grpc,
  proto-plus,
  protobuf,
  setuptools,

  # tests
  pytest-grpc,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "google-cloud-discoveryengine";
  version = "0.13.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-discoveryengine-v${version}";
    hash = "sha256-GfyXhgz04E8RkExawkWKrCyCvZ/YRRN2goqZV3eybP8=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-discoveryengine";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    grpc
    proto-plus
    protobuf
  ];

  nativeCheckInputs = [
    pytest-grpc
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "google.cloud.discoveryengine_v1" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "google-cloud-discoveryengine-v";
  };

  meta = {
    changelog = "https://github.com/googleapis/google-cloud-python/releases/tag/${src.tag}";
    description = "Python Client for Google Cloud Discovery Engine API";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-discoveryengine";
    license = lib.licenses.asl20;
    maintainers = [
      lib.maintainers.eu90h
    ];
  };
}
