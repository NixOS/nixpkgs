{ lib
, buildPythonPackage
, fetchFromGitHub
, py
, pytest-benchmark
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "getmac";
  version = "0.8.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GhostofGoes";
    repo = pname;
    rev = version;
    sha256 = "sha256-X4uuYisyobCxhoywaSXBZjVxrPAbBiZrWUJAi2/P5mw=";
  };

  checkInputs = [
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
  ];

  pythonImportsCheck = [
    "getmac"
  ];

  meta = with lib; {
    description = "Python package to get the MAC address of network interfaces and hosts on the local network";
    homepage = "https://github.com/GhostofGoes/getmac";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
