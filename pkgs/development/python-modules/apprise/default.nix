{ lib
, babel
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
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-92eoBwp3fcKb9zCBeeC2ndLeZeZpM+2JsZmef/5yO2A=";
  };

  nativeBuildInputs = [
    babel
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
