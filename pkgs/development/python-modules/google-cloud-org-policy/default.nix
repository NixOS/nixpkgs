{ lib, buildPythonPackage, fetchPypi, pythonOlder, google-api-core }:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ncgcnbvmgqph54yh2pjx2hh82gnkhsrw5yirp4wlf7jclh6j9xh";
  };

  propagatedBuildInputs = [ google-api-core ];

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
