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
, pytestCheckHook
, mock
, nose
, pythonOlder
}:

# TODO: Define this package in "all-packages.nix" using "toPythonApplication".
# This currently errors out, complaining about not being able to find "etree" from "lxml" even though "lxml" is defined in "propagatedBuildInputs".

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
