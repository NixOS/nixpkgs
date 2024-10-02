{
  lib,
  apprise,
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
  testers,
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tck6/WMxr+S2OlXRzqkHbke+y0uom1YrGBwT4luwx9Y=";
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
    # Nondeterministic. Fails with `assert 3 == 2`
    "test_plugin_matrix_transaction_ids_api_v3"
    # Nondeterministic. Fails with `AssertionError`
    "test_plugin_xbmc_kodi_urls"
    # Nondeterministic. Fails with `AssertionError`
    "test_plugin_zulip_urls"
  ];

  disabledTestPaths = [
    # AttributeError: module 'apprise.plugins' has no attribute 'NotifyBulkSMS'
    "test/test_plugin_bulksms.py"
    # Nondeterministic. Multiple tests will fail with `AssertionError`
    "test/test_plugin_workflows.py"
  ];

  postInstall = ''
    installManPage packaging/man/apprise.1
  '';

  pythonImportsCheck = [ "apprise" ];

  passthru = {
    tests.version = testers.testVersion {
      package = apprise;
      version = "v${version}";
    };
  };

  meta = {
    description = "Push Notifications that work with just about every platform";
    homepage = "https://github.com/caronc/apprise";
    changelog = "https://github.com/caronc/apprise/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "apprise";
  };
}
