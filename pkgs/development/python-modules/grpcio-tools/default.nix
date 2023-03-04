{ lib, buildPythonPackage, fetchPypi, protobuf, grpcio, setuptools }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.52.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wD6X5M1kMnavIQDL3Mn2sTBLHbeeWflXWMMCOj7kvVQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'protobuf>=4.21.6,<5.0dev' 'protobuf'
  '';

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [ protobuf grpcio setuptools ];

  # no tests in the package
  doCheck = false;

  pythonImportsCheck = [ "grpc_tools" ];

  meta = with lib; {
    description = "Protobuf code generator for gRPC";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ ];
  };
}
