{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  py,
  pytest-benchmark,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "getmac";
  version = "0.9.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GhostofGoes";
    repo = "getmac";
    tag = version;
    hash = "sha256-ZbTCbbASs7+ChmgcDePXSbiHOst6/eCkq9SiKgYhFyM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    py
    pytest-benchmark
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Disable CLI tests
    "test_cli_main_basic"
    "test_cli_main_verbose"
    "test_cli_main_debug"
    "test_cli_multiple_debug_levels"
    # Disable test that require network access
    "test_uuid_lanscan_iface"
    # Mocking issue
    "test_initialize_method_cache_valid_types"
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "getmac" ];

  meta = with lib; {
    description = "Python package to get the MAC address of network interfaces and hosts on the local network";
    homepage = "https://github.com/GhostofGoes/getmac";
    changelog = "https://github.com/GhostofGoes/getmac/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "getmac";
  };
}
