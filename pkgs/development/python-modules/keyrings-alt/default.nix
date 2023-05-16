{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, jaraco-classes
, keyring
, pytestCheckHook
, pythonOlder
=======
, pythonOlder
, isPy27
, six

, pytestCheckHook
, keyring
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm
}:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "keyrings-alt";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "keyrings.alt";
    inherit version;
    hash = "sha256-nURstHu86pD/ouzD6AA6z0FXP8IBv0S0vxO9DhFISCg=";
=======
  pname = "keyrings.alt";
  version = "4.2.0";
  format = "pyproject";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K6PVZEG6Bjf1+cCWBo9nAQrART+dC2Jt4qowGTU7ZDE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    jaraco-classes
=======
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
    keyring
  ];

  pythonImportsCheck = [
    "keyrings.alt"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Alternate keyring implementations";
    homepage = "https://github.com/jaraco/keyrings.alt";
    changelog = "https://github.com/jaraco/keyrings.alt/blob/v${version}/NEWS.rst";
    license = licenses.mit;
=======
    license = licenses.mit;
    description = "Alternate keyring implementations";
    homepage = "https://github.com/jaraco/keyrings.alt";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ nyarly ];
  };
}
