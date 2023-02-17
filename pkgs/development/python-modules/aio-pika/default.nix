{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, aiormq
, yarl
, aiomisc
, shortuuid
}:

buildPythonPackage rec {
  pname = "aio-pika";
  version = "8.3.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = version;
    sha256 = "CYfj6V/91J7JA8YSctG/FkSHRkwyLKxr27eREbA+MtQ=";
  };

  propagatedBuildInputs = [
    aiormq
    yarl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  checkInputs = [
    aiomisc
    shortuuid
  ];
  # Tests attempt to connect to a RabbitMQ server
  disabledTestPaths = [
    "tests/test_amqp.py"
    "tests/test_amqp_robust.py"
    "tests/test_amqp_robust_proxy.py"
    "tests/test_amqps.py"
    "tests/test_master.py"
    "tests/test_memory_leak.py"
    "tests/test_rpc.py"
    "tests/test_types.py"
  ];
  pythonImportsCheck = [ "aio_pika" ];

  meta = with lib; {
    description = "AMQP 0.9 client designed for asyncio and humans";
    homepage = "https://github.com/mosquito/aio-pika";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
