{ lib, buildPythonPackage, fetchPypi, googleapis-common-protos, protobuf }:

buildPythonPackage rec {
  pname = "google-cloud-audit-log";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0852f525ad65705f9fbff6288be4493e1449a7906fb5e01bd71c8d1e424d1fc";
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
