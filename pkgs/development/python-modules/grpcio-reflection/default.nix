{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, grpcio
, protobuf
}:

buildPythonPackage rec {
  pname = "grpcio-reflection";
  version = "1.62.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q9RTABmRhxAxMV7y2Cr/6TCAwEM/o6AHvjS/Qn4oqIo=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
  pythonRelaxDeps = [
    "grpcio"
  ];

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [ "grpc_reflection" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Standard Protobuf Reflection Service for gRPC";
    homepage = "https://pypi.org/project/grpcio-reflection";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
  };
}
