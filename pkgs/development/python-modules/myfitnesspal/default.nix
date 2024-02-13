{ lib
, blessed
, browser-cookie3
, buildPythonPackage
, cloudscraper
, fetchPypi
, keyring
, keyrings-alt
, lxml
, measurement
, mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, rich
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "myfitnesspal";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H9oKSio+2x4TDCB4YN5mmERUEeETLKahPlW3TDDFE/E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    blessed
    browser-cookie3
    cloudscraper
    keyring
    keyrings-alt
    lxml
    measurement
    python-dateutil
    requests
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    mock
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
