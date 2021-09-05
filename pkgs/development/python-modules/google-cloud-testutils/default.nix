{ lib, buildPythonPackage, fetchPypi, click, google-auth, six }:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2RaRhRvgnmr/trjAE+RBlVO5AZ54YEFcoRwcPCKCTKs=";
  };

  propagatedBuildInputs = [ click google-auth six ];

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [ "test_utils" ];

  meta = with lib; {
    description = "System test utilities for google-cloud-python";
    homepage = "https://github.com/googleapis/python-test-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
