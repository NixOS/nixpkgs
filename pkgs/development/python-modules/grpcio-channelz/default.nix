{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  protobuf,
}:

buildPythonPackage rec {
  pname = "grpcio-channelz";
  version = "1.62.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bkrCxD12skXF9m2Y9SPbCHhrGGEoplXubyCjCn5o5Pk=";
  };

  pythonRelaxDeps = [ "grpcio" ];

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
