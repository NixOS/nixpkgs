{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  packaging,
  parameterized,
  msgpack,
  pyserial,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  typing-extensions,
  wrapt,
  uptime,
}:

buildPythonPackage rec {
  pname = "python-can";
  version = "4.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hardbyte";
    repo = "python-can";
    tag = "v${version}";
    hash = "sha256-yF/Ir9FUf9Q8GINeT0H4SixzZGetqumU5N6O3GT3M6A=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    msgpack
    packaging
    typing-extensions
    wrapt
  ];

  optional-dependencies = {
    serial = [ pyserial ];
    seeedstudio = [ pyserial ];
    pcan = [ uptime ];
  };

  nativeCheckInputs = [
    hypothesis
    parameterized
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
  ++ optional-dependencies.serial;

  disabledTestPaths = [
    # We don't support all interfaces
    "test/test_interface_canalystii.py"
  ];

  disabledTests = [
    # Tests require access socket
    "BasicTestUdpMulticastBusIPv4"
    "BasicTestUdpMulticastBusIPv6"
    # pytest.approx is not supported in a boolean context (since pytest7)
    "test_pack_unpack"
    "test_receive"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # timing sensitive
    "test_general"
    "test_gap"
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
    # skips timing senstive tests
    export CI=1
  '';

  pythonImportsCheck = [ "can" ];

  meta = {
    description = "CAN support for Python";
    homepage = "https://python-can.readthedocs.io";
    changelog = "https://github.com/hardbyte/python-can/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      fab
      sorki
    ];
  };
}
