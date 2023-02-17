{ lib
, buildPythonPackage
, click
, fetchPypi
, google-auth
, packaging
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "1.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bRjvNNmvsBy0sR4C0DoC/n7A9ez6AfXUJrXZiHKkz0g=";
  };

  propagatedBuildInputs = [
    click
    google-auth
    packaging
  ];

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [
    "test_utils"
  ];

  meta = with lib; {
    description = "System test utilities for google-cloud-python";
    homepage = "https://github.com/googleapis/python-test-utils";
    changelog  ="https://github.com/googleapis/python-test-utils/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
