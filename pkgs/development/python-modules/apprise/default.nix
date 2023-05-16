{ lib
, babel
, buildPythonPackage
, click
, cryptography
, fetchPypi
, gntp
, installShellFiles
, markdown
, paho-mqtt
, pytest-mock
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "apprise";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-PFgRQQd6EBeQ7eDKsW+ig60DKpsvl9xtNWX7LZGBP9c=";
=======
    hash = "sha256-LFDBml3UExex9lnFKyGpkP6+bBXghGQiihzo5gmPEb8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    click
    cryptography
    markdown
    pyyaml
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    babel
    gntp
    paho-mqtt
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    "test_apprise_cli_nux_env"
    "test_plugin_mqtt_general"
  ];

  disabledTestPaths = [
    # AttributeError: module 'apprise.plugins' has no attribute 'NotifyBulkSMS'
    "test/test_plugin_bulksms.py"
  ];

  postInstall = ''
    installManPage packaging/man/apprise.1
  '';

  pythonImportsCheck = [
    "apprise"
  ];

  meta = with lib; {
    description = "Push Notifications that work with just about every platform";
    homepage = "https://github.com/caronc/apprise";
    changelog = "https://github.com/caronc/apprise/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
