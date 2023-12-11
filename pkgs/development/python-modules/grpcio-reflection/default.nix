{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, grpcio
, protobuf
}:

buildPythonPackage rec {
  pname = "grpcio-reflection";
  version = "1.59.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VAPFpzjG7sS7QIDad+RQMS2s5BqG4pKsN8/QB7JlfU4=";
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
