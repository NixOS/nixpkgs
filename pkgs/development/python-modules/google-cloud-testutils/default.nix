{ lib, buildPythonPackage, fetchPypi, click, google-auth, six }:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d79051b6ca170c2a4f159bf56ac3f66c1e5360486121e72c06fdaa3911154bf";
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
