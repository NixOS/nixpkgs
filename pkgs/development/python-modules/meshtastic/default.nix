{
  lib,
  argcomplete,
  bleak,
  buildPythonPackage,
  dash-bootstrap-components,
  dash,
  dotmap,
  fetchFromGitHub,
  hypothesis,
  packaging,
  pandas-stubs,
  pandas,
  parse,
  platformdirs,
  poetry-core,
  ppk2-api,
  print-color,
  protobuf,
  pyarrow,
  pypubsub,
  pyqrcode,
  pyserial,
  pytap2,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  riden,
  setuptools,
  tabulate,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "meshtastic";
  version = "2.7.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "python";
    tag = version;
    hash = "sha256-9p9tDc74WpH0+8orI69bW2Yj7Cow4v7M3cotIbk/mcw=";
  };

  pythonRelaxDeps = [
    "bleak"
    "packaging"
    "protobuf"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    packaging
    protobuf
    pypubsub
    pyserial
    pyyaml
    requests
    setuptools
    tabulate
  ];

  optional-dependencies = {
    analysis = [
      dash
      dash-bootstrap-components
      pandas
      pandas-stubs
    ];
    cli = [
      argcomplete
      dotmap
      print-color
      pyqrcode
      wcwidth
    ];
    powermon = [
      parse
      platformdirs
      ppk2-api
      pyarrow
      riden
    ];
    tunnel = [ pytap2 ];
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [ "meshtastic" ];

  disabledTestPaths = [
    # Circular import with dash-bootstrap-components
    "meshtastic/tests/test_analysis.py"
  ];

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
    "test_node"
    "test_SerialInterface_single_port"
    "test_support_info"
    "test_TCPInterface"
  ];

  meta = with lib; {
    description = "Python API for talking to Meshtastic devices";
    homepage = "https://github.com/meshtastic/python";
    changelog = "https://github.com/meshtastic/python/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
