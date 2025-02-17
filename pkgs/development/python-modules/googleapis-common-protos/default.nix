{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpc,
  protobuf,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.66.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "googleapis_common_protos";
    inherit version;
    hash = "sha256-w+ezPRX9ylN0zApzRt2S/6hHQlzE6pQdlw8TaABS7Iw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    grpc
    protobuf
  ];

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [
    "google.api"
    "google.logging"
    "google.longrunning"
    "google.rpc"
    "google.type"
  ];

  meta = with lib; {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/python-api-common-protos";
    changelog = "https://github.com/googleapis/python-api-common-protos/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
