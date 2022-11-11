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
}:

buildPythonPackage rec {
  pname = "python-can";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hardbyte";
    repo = pname;
    rev = version;
    hash = "sha256-/z7zBfVbO7x4UtzWOXolH2YrtYWgsvRLObWwz8sqOEc=";
  };

  propagatedBuildInputs = [
    msgpack
    packaging
    pyserial
    typing-extensions
    wrapt
  ];

  checkInputs = [
    future
    hypothesis
    parameterized
    pytest-timeout
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov=can --cov-config=tox.ini --cov-report=xml --cov-report=term" ""
  '';

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
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab sorki ];
  };
}
