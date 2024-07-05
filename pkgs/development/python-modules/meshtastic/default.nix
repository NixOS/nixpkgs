{
  lib,
  bleak,
  buildPythonPackage,
  dotmap,
  fetchFromGitHub,
  packaging,
  pexpect,
  protobuf,
  pygatt,
  pypubsub,
  pyqrcode,
  pyserial,
  pytap2,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  tabulate,
  timeago,
}:

buildPythonPackage rec {
  pname = "meshtastic";
  version = "2.3.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "Meshtastic-python";
    rev = "refs/tags/${version}";
    hash = "sha256-WxiddF1n9lyxKkZk1MU40NzLh6goLVs81mbJZ3F33R8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    dotmap
    packaging
    pexpect
    protobuf
    pygatt
    pypubsub
    pyqrcode
    pyserial
    pyyaml
    requests
    setuptools
    tabulate
    timeago
  ];

  passthru.optional-dependencies = {
    tunnel = [ pytap2 ];
  };

  nativeCheckInputs = [
    pytap2
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [ "meshtastic" ];

  disabledTests = [
    # TypeError
    "test_main_info_with_seriallog_output_txt"
    "test_main_info_with_seriallog_stdout"
    "test_main_info_with_tcp_interfa"
    "test_main_info"
    "test_main_no_proto"
    "test_main_support"
    "test_MeshInterface"
    "test_message_to_json_shows_all"
    "test_SerialInterface_single_port"
    "test_support_info"
    "test_TCPInterface"
  ];

  meta = with lib; {
    description = "Python API for talking to Meshtastic devices";
    homepage = "https://github.com/meshtastic/Meshtastic-python";
    changelog = "https://github.com/meshtastic/python/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
