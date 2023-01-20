{ lib
, fetchPypi
, buildPythonPackage
, blessed
, browser-cookie3
, keyring
, keyrings-alt
, lxml
, measurement
, python-dateutil
, requests
, rich
, typing-extensions
, pytestCheckHook
, mock
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "myfitnesspal";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wlQ/mo9MBQo0t1p0h6/TJir3I87DKYAUc022T3hZjH8=";
  };

  propagatedBuildInputs = [
    blessed
    browser-cookie3
    keyring
    keyrings-alt
    lxml
    measurement
    python-dateutil
    requests
    rich
    typing-extensions
  ];

  checkInputs = [
    mock
    nose
    pytestCheckHook
  ];

  postPatch = ''
    # Remove overly restrictive version constraints
    sed -i -e "s/>=.*//" requirements.txt
  '';

  disabledTests = [
    # Integration tests require an account to be set
    "test_integration"
  ];

  pythonImportsCheck = [
    "myfitnesspal"
  ];

  meta = with lib; {
    description = "Python module to access meal tracking data stored in MyFitnessPal";
    homepage = "https://github.com/coddingtonbear/python-myfitnesspal";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
