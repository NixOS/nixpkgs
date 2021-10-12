{ lib, buildPythonPackage, fetchPypi, googleapis-common-protos, protobuf }:

buildPythonPackage rec {
  pname = "google-cloud-audit-log";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a87fdf3c393b830b35c8f7db09094790d0d7babb35068736bea64e1618d286fe";
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
