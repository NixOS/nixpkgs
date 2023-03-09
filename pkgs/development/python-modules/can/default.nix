{ lib
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
, typing-extensions
, wrapt
, uptime
}:

buildPythonPackage rec {
  pname = "can";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hardbyte";
    repo = "python-can";
    rev = "refs/tags/v${version}";
    hash = "sha256-jNy47SapujTF3ReJtIbwUY53IftIH4cXZjkzHrnZMFQ=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov=can --cov-config=tox.ini --cov-report=lcov --cov-report=term" ""
  '';

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
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
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
