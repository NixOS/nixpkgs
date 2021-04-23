{ lib, buildPythonPackage, fetchPypi, pythonOlder, google-api-core, proto-plus }:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tGNwSv+rMnwdP6SvKAqFhjW19ZqIRWsqCNtiozajUqo=";
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
