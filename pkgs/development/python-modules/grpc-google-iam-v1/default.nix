{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, grpcio
, googleapis-common-protos
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.12.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AJGXp/HqqiIUnJbl4FSsWTS6ckGXTpJmPY01KKISA9E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    grpcio
    googleapis-common-protos
  ];

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
