{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchPypi
, grpcio
, protobuf
}:

buildPythonPackage rec {
  pname = "grpcio-health-checking";
  version = "1.56.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XNodihNovizaBPkoSotzzuCf8+J37sjd2avPL+92s3I=";
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
