{ lib
, aiomisc-pytest
, aiormq
, buildPythonPackage
, fetchFromGitHub
, pamqp
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
, shortuuid
, typing-extensions
, yarl
}:

buildPythonPackage rec {
  pname = "aio-pika";
  version = "9.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Fy3vTXfj+gu/+PYWPfcOZ/D7boRiZYcFPX29p28HoGs=";
  };

  nativeBuildInputs = [
    setuptools
    poetry-core
  ];

  propagatedBuildInputs = [
    aiormq
    yarl
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    aiomisc-pytest
    pamqp
    pytestCheckHook
    shortuuid
  ];

  disabledTestPaths = [
    # Tests attempt to connect to a RabbitMQ server
    "tests/test_amqp.py"
    "tests/test_amqp_robust.py"
    "tests/test_amqp_robust_proxy.py"
    "tests/test_amqps.py"
    "tests/test_master.py"
    "tests/test_memory_leak.py"
    "tests/test_rpc.py"
    "tests/test_types.py"
  ];

  pythonImportsCheck = [
    "aio_pika"
  ];

  meta = with lib; {
    description = "AMQP 0.9 client designed for asyncio and humans";
    homepage = "https://github.com/mosquito/aio-pika";
    changelog = "https://github.com/mosquito/aio-pika/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
