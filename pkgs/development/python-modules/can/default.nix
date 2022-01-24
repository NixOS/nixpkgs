{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, hypothesis
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
  version = "unstable-2022-01-11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hardbyte";
    repo = pname;
    rev = "2e24af08326ecd69fba9f02fed7b9c26f233c92b";
    hash = "sha256-ZP5qtbjDtBZ2uT9DOSvSnfHyTlirr0oCEXhiLO1ydz0=";
  };

  propagatedBuildInputs = [
    msgpack
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
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [
    "can"
  ];

  meta = with lib; {
    description = "CAN support for Python";
    homepage = "python-can.readthedocs.io";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab sorki ];
  };
}
