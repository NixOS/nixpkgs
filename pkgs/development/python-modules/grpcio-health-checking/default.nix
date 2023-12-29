{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, grpcio
, protobuf
}:

buildPythonPackage rec {
  pname = "grpcio-health-checking";
  version = "1.60.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R4tTAHeBIP7Z9tE01ysVeln5wGaJeJIYy/9H+vyi8Rk=";
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
