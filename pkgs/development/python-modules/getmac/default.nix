{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  py,
  pytest-benchmark,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "getmac";
  version = "0.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GhostofGoes";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-B9agBmSrD3ZhqpGclZdMQNRSLSkepR6iduP1yrYz9tU=";
  };

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-benchmark
    pytest-mock
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

  pythonImportsCheck = [ "getmac" ];

  meta = with lib; {
    description = "Python package to get the MAC address of network interfaces and hosts on the local network";
    mainProgram = "getmac";
    homepage = "https://github.com/GhostofGoes/getmac";
    changelog = "https://github.com/GhostofGoes/getmac/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
