{ lib
, buildPythonPackage
, fetchPypi
, grpcio
, googleapis-common-protos
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.12.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PwrCyUC5qFXXzn4x/eKL3bDZrDYtMtB8ZxSDBpMaDjA=";
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
