{ lib
, buildPythonPackage
, fetchPypi
, grpcio
, protobuf
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "grpcio-testing";
  version = "1.60.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XF+za8O9x4m/8ewEBQG5reoPiK64vh7VyA1oic0Jq0A=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"grpcio>={version}".format(version=grpc_version.VERSION)' '"grpcio"'
  '';

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [
    "grpc_testing"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Testing utilities for gRPC Python";
    homepage = "https://grpc.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
