{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  protobuf,
  pythonOlder,
  pythonRelaxDepsHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpcio-testing";
  version = "1.62.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dNGeGQnpQbGmvvf71fnvMwWZ9nb7BrsGB8hFDtVVnfI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"grpcio>={version}".format(version=grpc_version.VERSION)' '"grpcio"'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [ "grpc_testing" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Testing utilities for gRPC Python";
    homepage = "https://grpc.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
