{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  py,
  pytest-benchmark,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "getmac";
  version = "0.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GhostofGoes";
    repo = "getmac";
    tag = version;
    hash = "sha256-dyuu2P7I4Ce5KJtreTGWYIv0UnSn9b4Y6JfcsBDeD/0=";
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

  meta = {
    description = "Python package to get the MAC address of network interfaces and hosts on the local network";
    homepage = "https://github.com/GhostofGoes/getmac";
    changelog = "https://github.com/GhostofGoes/getmac/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "getmac";
  };
}
