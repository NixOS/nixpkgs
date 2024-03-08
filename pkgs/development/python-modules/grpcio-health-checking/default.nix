{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, grpcio
, protobuf
}:

buildPythonPackage rec {
  pname = "grpcio-health-checking";
  version = "1.62.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f8JjBFMP2KwGukvtvcGUpWPFXiGKv/QJy68d5xkUk3s=";
  };

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
  pythonRelaxDeps = [
    "grpcio"
  ];

  pythonImportsCheck = [ "grpc_health" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Standard Health Checking Service for gRPC";
    homepage = "https://pypi.org/project/grpcio-health-checking/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
  };
}
