{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, grpc
, protobuf
}:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.62.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g/Ds6flOVnLM7YL1ktKl7fUnqW7ReU8LqzbVc1yZYnc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
