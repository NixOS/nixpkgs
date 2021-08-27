{ lib
, buildPythonPackage
, fetchPypi
, grpcio
, googleapis-common-protos
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bfb5b56f648f457021a91c0df0db4934b6e0c300bd0f2de2333383fe958aa72";
  };

  propagatedBuildInputs = [ grpcio googleapis-common-protos ];

  # no tests run
  doCheck = false;

  pythonImportsCheck = [
    "google.iam"
    "google.iam.v1"
  ];

  meta = with lib; {
    description = "GRPC library for the google-iam-v1 service";
    homepage = "https://github.com/googleapis/googleapis";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
