{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-benchmark
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "getmac";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "GhostofGoes";
    repo = pname;
    rev = version;
    sha256 = "08d4iv5bjl1s4i9qhzf3pzjgj1rgbwi0x26qypf3ycgdj0a6gvh2";
  };

  checkInputs = [
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
  ];

  pythonImportsCheck = [ "getmac" ];

  meta = with lib; {
    description = "Python package to get the MAC address of network interfaces and hosts on the local network";
    homepage = "https://github.com/GhostofGoes/getmac";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
