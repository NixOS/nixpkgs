{ lib, buildPythonPackage, fetchPypi, googleapis-common-protos, protobuf }:

buildPythonPackage rec {
  pname = "google-cloud-audit-log";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qr5VQ2ceT4qcekwOPqmoe6K6K5b5/61vqgIgmQDh8wg=";
  };

  propagatedBuildInputs = [ googleapis-common-protos protobuf ];

  # tests are a bit wonky to setup and are not very deep either
  doCheck = false;

  pythonImportsCheck = [ "google.cloud.audit" ];

  meta = with lib; {
    description = "Google Cloud Audit Protos";
    homepage = "https://github.com/googleapis/python-audit-log";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
