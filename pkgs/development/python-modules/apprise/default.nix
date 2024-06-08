{
  lib,
  babel,
  buildPythonPackage,
  click,
  cryptography,
  fetchPypi,
  gntp,
  installShellFiles,
  markdown,
  paho-mqtt,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  requests-oauthlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6PWM6/6ho09WnLTGiAmjF1voDsBvCi7Ec1IrkgIyEsU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = [
    babel
    setuptools
  ];

  dependencies = [
    click
    cryptography
    markdown
    pyyaml
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    gntp
    paho-mqtt
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    "test_apprise_cli_nux_env"
    # Nondeterministic. Fails with `assert 0 == 1`
    "test_notify_emoji_general"
    "test_plugin_mqtt_general"
    # Nondeterministic. Fails with `AssertionError`
    "test_plugin_xbmc_kodi_urls"
  ];

  disabledTestPaths = [
    # AttributeError: module 'apprise.plugins' has no attribute 'NotifyBulkSMS'
    "test/test_plugin_bulksms.py"
  ];

  postInstall = ''
    installManPage packaging/man/apprise.1
  '';

  pythonImportsCheck = [ "apprise" ];

  meta = with lib; {
    description = "Push Notifications that work with just about every platform";
    homepage = "https://github.com/caronc/apprise";
    changelog = "https://github.com/caronc/apprise/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ getchoo ];
    mainProgram = "apprise";
  };
}
