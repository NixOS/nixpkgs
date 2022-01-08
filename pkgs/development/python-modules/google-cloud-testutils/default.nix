{ lib, buildPythonPackage, fetchPypi, click, google-auth, six }:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c60ea86b28998935875b5aea0b89b0a3aac5e433e0039236f633c5d0ff5f8b8";
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
