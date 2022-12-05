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
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bjGvoY9HRS6szVb7fug9kkUsU00V85JAftGg48RlJEs=";
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

  checkInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
