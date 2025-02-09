{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, future
, hypothesis
, packaging
, parameterized
, msgpack
, pyserial
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
, typing-extensions
, wrapt
, uptime
}:

buildPythonPackage rec {
  pname = "can";
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hardbyte";
    repo = "python-can";
    rev = "refs/tags/v${version}";
    hash = "sha256-t2zt54nPOYcEE0RPb4fbW7sN4HzFXlDIHvHudstBwrM=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov=can --cov-config=tox.ini --cov-report=lcov --cov-report=term" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    msgpack
    packaging
    typing-extensions
    wrapt
  ];

  passthru.optional-dependencies = {
    serial = [
      pyserial
    ];
    seeedstudio = [
      pyserial
    ];
    pcan = [
      uptime
    ];
  };

  nativeCheckInputs = [
    future
    hypothesis
    parameterized
    pytest-timeout
    pytestCheckHook
  ] ++ passthru.optional-dependencies.serial;

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
  ] ++ lib.optionals stdenv.isDarwin [
    # timing sensitive
    "test_general"
    "test_gap"
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
    # skips timing senstive tests
    export CI=1
  '';

  pythonImportsCheck = [
    "can"
  ];

  meta = with lib; {
    description = "CAN support for Python";
    homepage = "https://python-can.readthedocs.io";
    changelog = "https://github.com/hardbyte/python-can/releases/tag/v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab sorki ];
  };
}
