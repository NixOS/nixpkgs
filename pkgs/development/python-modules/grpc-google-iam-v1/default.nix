{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  googleapis-common-protos,
  grpcio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "grpc-google-iam-v1-v${version}";
    hash = "sha256-5PzidE1CWN+pt7+gcAtbuXyL/pq6cnn0MCRkBfmeUSw=";
  };

  sourceRoot = "${src.name}/packages/grpc-google-iam-v1";

  build-system = [ setuptools ];

  dependencies = [
    grpcio
    googleapis-common-protos
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "google.iam"
    "google.iam.v1"
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "GRPC library for the google-iam-v1 service";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/grpc-google-iam-v1";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/grpc-google-iam-v1/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
