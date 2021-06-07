{ lib, buildPythonPackage, fetchPypi, pythonOlder, google-api-core, proto-plus }:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b463704affab327c1d3fa4af280a858635b5f59a88456b2a08db62a336a352aa";
  };

  propagatedBuildInputs = [ google-api-core proto-plus ];

  # No tests in repo
  doCheck = false;

  pythonImportsCheck = [ "google.cloud.orgpolicy" ];

  meta = with lib; {
    description = "Protobufs for Google Cloud Organization Policy.";
    homepage = "https://github.com/googleapis/python-org-policy";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
  };
}
