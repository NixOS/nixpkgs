{ lib
, Babel
, buildPythonPackage
, click
, cryptography
, fetchPypi
, gntp
, installShellFiles
, markdown
, mock
, paho-mqtt
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, requests-oauthlib
, six
, slixmpp
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.9.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EDKa77sU09HOBp4NVsHNwp6S4UbHyqX8T8rFGOnV8kA=";
  };

  nativeBuildInputs = [
    Babel
    installShellFiles
  ];

  propagatedBuildInputs = [
    click
    cryptography
    markdown
    pyyaml
    requests
    requests-oauthlib
    six
  ];

  checkInputs = [
    gntp
    mock
    paho-mqtt
    pytestCheckHook
    slixmpp
  ];

  disabledTests = [
    "test_apprise_cli_nux_env"
    "test_plugin_mqtt_general"
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
