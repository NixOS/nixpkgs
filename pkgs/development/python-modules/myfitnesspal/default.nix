{ lib
, fetchPypi
, buildPythonPackage
, blessed
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
  version = "1.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UXFvKQtC44EvscYWXK7KI/do3U0wTWI3zKwvsRdzKrs=";
  };

  propagatedBuildInputs = [
    blessed
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
