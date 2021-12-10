{ lib, buildPythonPackage, fetchFromGitHub, googleapis-common-protos, protobuf }:

buildPythonPackage rec {
  pname = "google-cloud-audit-log";
  version = "0.2.0";

  src = fetchFromGitHub {
     owner = "googleapis";
     repo = "python-audit-log";
     rev = "v0.2.0";
     sha256 = "06m3m3m0khdryg1l51q7640vs2zvvjrhak8dy2hz16m0g189slh7";
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
