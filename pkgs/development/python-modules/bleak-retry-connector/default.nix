{ lib
, async-timeout
, bleak
, dbus-fast
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "bleak-retry-connector";
  version = "1.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-IDfamUZB9WJH+ybZ0ULBSEd1koMHTZ1/DaFTf6oviM8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bleak_retry_connector --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
    bleak
    dbus-fast
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # broken mocking
    "test_establish_connection_can_cache_services_services_missing"
    "test_establish_connection_with_dangerous_use_cached_services"
    "test_establish_connection_without_dangerous_use_cached_services"
  ];

  pythonImportsCheck = [
    "bleak_retry_connector"
  ];

  meta = with lib; {
    description = "Connector for Bleak Clients that handles transient connection failures";
    homepage = "https://github.com/bluetooth-devices/bleak-retry-connector";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
