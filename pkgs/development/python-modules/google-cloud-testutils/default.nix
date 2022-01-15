{ lib, buildPythonPackage, fetchPypi, click, google-auth, six }:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a755c1247e32e92bd6df4fa2240dab185b29da9777ab3b946c3b3d9f1abf5d3";
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
