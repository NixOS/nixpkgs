{
  lib,
  async-timeout,
  bleak,
  bluetooth-adapters,
  dbus-fast,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "bleak-retry-connector";
  version = "3.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bleak-retry-connector";
    rev = "refs/tags/v${version}";
    hash = "sha256-WjowXfj9kPlMmfs3aJBHIux5/w6te7zpXXqXPaz2pks=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=bleak_retry_connector --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    async-timeout
    bleak
    bluetooth-adapters
    dbus-fast
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # broken mocking
    "test_establish_connection_can_cache_services_services_missing"
    "test_establish_connection_with_dangerous_use_cached_services"
    "test_establish_connection_without_dangerous_use_cached_services"
  ];

  pythonImportsCheck = [ "bleak_retry_connector" ];

  meta = with lib; {
    description = "Connector for Bleak Clients that handles transient connection failures";
    homepage = "https://github.com/bluetooth-devices/bleak-retry-connector";
    changelog = "https://github.com/bluetooth-devices/bleak-retry-connector/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
