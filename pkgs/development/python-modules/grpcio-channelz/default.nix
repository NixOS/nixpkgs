{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  grpcio,
  protobuf,
}:

buildPythonPackage rec {
  pname = "grpcio-channelz";
  version = "1.65.4";
  pyproject = true;

  src = fetchPypi {
    pname = "grpcio_channelz";
    inherit version;
    hash = "sha256-Ia92P8FT3+bv18k402znrt3QTDovPBCgCJ/Eqm8WDic=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "grpcio"
    "protobuf"
  ];

  dependencies = [
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
