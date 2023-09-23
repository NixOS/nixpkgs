{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, googleapis-common-protos
, grpcio
, protobuf
, requests
}:

buildPythonPackage rec {
  pname = "clarifai-grpc";
  version = "9.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hUx+dUx0Lkz6sEZizHqH8ONk2r19D9MIVuefhBmjEiQ=";
  };

  propagatedBuildInputs = [
    googleapis-common-protos
    grpcio
    protobuf
    requests
  ];

  # almost all tests require network access
  doCheck = false;

  pythonImportsCheck = [ "clarifai_grpc" ];

  meta = with lib; {
    description = "Clarifai gRPC API Client";
    homepage = "https://github.com/Clarifai/clarifai-python-grpc";
    changelog = "https://github.com/Clarifai/clarifai-python-grpc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
