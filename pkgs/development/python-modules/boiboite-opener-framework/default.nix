{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pytestCheckHook,
  pythonOlder,
  scapy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "boiboite-opener-framework";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Orange-Cyberdefense";
    repo = "bof";
    rev = "refs/tags/${version}";
    hash = "sha256-atKqHRX24UjF/9Dy0aYXAN+80nBJKCd07FmaR5Vl1q4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "scapy==2.5.0rc1" "scapy"
  '';

  build-system = [ setuptools ];

  dependencies = [
    packaging
    scapy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bof" ];

  disabledTests = [
    # Tests are using netcat and cat to do UDP connections
    "test_0101_knxnet_instantiate"
    "test_0101_modbusnet_instantiate"
    "test_0102_knxnet_connect"
    "test_0102_modbusnet_connect"
    "test_0201_knxnet_send_knxpacket"
    "test_0201_modbus_send_modbuspacket"
    "test_0201_udp_send_str_bytes"
    "test_0202_knxnet_send_knxpacket"
    "test_0202_modbus_send_modbuspacket"
    "test_0202_udp_send_receive"
    "test_0203_knxnet_send_raw"
    "test_0203_modbus_send_raw"
    "test_0203_send_receive_timeout"
    "test_0204_knxnet_receive"
    "test_0204_modbus_receive"
    "test_0204_multicast_error_handling"
    "test_0205_broadcast_error_handling"
    "test_0301_pndcp_device_raise"
    "test_0301_tcp_instantiate"
    "test_0302_tcp_connect"
    "test_0303_tcp_connect_bad_addr"
    "test_0304_tcp_connect_bad_port"
    "test_0401_tcp_send_str_bytes"
    "test_0402_tcp_send_receive"
    "test_0802_search_valid"
  ];

  meta = with lib; {
    description = "Testing framework for industrial protocols implementations and devices";
    homepage = "https://github.com/Orange-Cyberdefense/bof";
    changelog = "https://github.com/Orange-Cyberdefense/bof/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
