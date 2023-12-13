{ lib
, buildPythonPackage
, fetchPypi
, grpcio
, googleapis-common-protos
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.12.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K8S4/fIhFaZddRyTFzKTImAsObfIaiicm3LSKNlg718=";
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
    maintainers = with maintainers; [ ];
  };
}
