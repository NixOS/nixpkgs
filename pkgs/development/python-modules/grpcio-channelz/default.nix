{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, grpcio
, protobuf
}:

buildPythonPackage rec {
  pname = "grpcio-channelz";
  version = "1.59.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-apOnMd8EDU+ocj6fL/dkl3tqh6en/Q8H9K/lgvkqFN8=";
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
