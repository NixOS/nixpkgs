{ lib
, buildPythonPackage
, fastnumbers
, fetchPypi
, glibcLocales
, hypothesis
, pyicu
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "natsort";
<<<<<<< HEAD
  version = "8.4.0";
=======
  version = "8.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-RTEsSg5VB1k9oZPe3QSrsUaSU7YB7K9jRFrYDwoepYE=";
=======
    hash = "sha256-UXWVSS3eVwpP1ranb2REQMG6UeIzjIpnHX8Edf2o+f0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    fastnumbers
    pyicu
  ];

  nativeCheckInputs = [
    glibcLocales
    hypothesis
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "natsort"
  ];

  meta = with lib; {
    description = "Natural sorting for Python";
    homepage = "https://github.com/SethMMorton/natsort";
    changelog = "https://github.com/SethMMorton/natsort/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
