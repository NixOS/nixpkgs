{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, grpcio
, protobuf
}:

buildPythonPackage rec {
  pname = "grpcio-channelz";
  version = "1.56.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PlPGrD16Iy5vCsuVsFQ3FHd+wu0FJCFbo7isvYtVAQU=";
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

  pythonImportsCheck = [ "grpc_channelz" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Channel Level Live Debug Information Service for gRPC";
    homepage = "https://pypi.org/project/grpcio-channelz";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
  };
}
