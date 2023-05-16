{ lib
, buildPythonPackage
, fetchPypi
, fixtures
, mock
, pbr
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
, requests
, testtools
=======
, pytest-cov
, pytestCheckHook
, pythonOlder
, requests
, six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pyopnsense";
<<<<<<< HEAD
  version = "0.4.0";

=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-3DKlVrOtMa55gTu557pgojRpdgrO5pEZ3L+9gKoW9yg=";
=======
    sha256 = "06rssdb3zhccnm63z96mw5yd38d9i99fgigfcdxn9divalbbhp5a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pbr
<<<<<<< HEAD
=======
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    requests
  ];

  nativeCheckInputs = [
    fixtures
    mock
<<<<<<< HEAD
    pytestCheckHook
    testtools
  ];

  pythonImportsCheck = [
    "pyopnsense"
  ];
=======
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyopnsense" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python client for the OPNsense API";
    homepage = "https://github.com/mtreinish/pyopnsense";
<<<<<<< HEAD
    changelog = "https://github.com/mtreinish/pyopnsense/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
