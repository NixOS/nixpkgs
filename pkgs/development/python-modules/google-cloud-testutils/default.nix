{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  google-auth,
  packaging,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1oocIuKssoUA1p2dxhqFy+nJjJtp4phwQnHN/L88C8s=";
  };

  propagatedBuildInputs = [
    click
    google-auth
    packaging
  ];

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [ "test_utils" ];

  meta = with lib; {
    description = "System test utilities for google-cloud-python";
    mainProgram = "lower-bound-checker";
    homepage = "https://github.com/googleapis/python-test-utils";
    changelog = "https://github.com/googleapis/python-test-utils/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
