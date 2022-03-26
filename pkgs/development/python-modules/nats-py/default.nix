{ lib
, buildPythonPackage
, ed25519
, fetchFromGitHub
, nats-server
, pytestCheckHook
, pythonOlder
, uvloop
}:

buildPythonPackage rec {
  pname = "nats-py";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.py";
    rev = "v${version}";
    hash = "sha256-BraT30J7OIcW2NXAwjcg9PYu+kgf8f1iDjKiN9J6l7Y=";
  };

  propagatedBuildInputs = [
    ed25519
  ];

  checkInputs = [
    nats-server
    pytestCheckHook
    uvloop
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=nats --cov-report html" ""
  '';

  disabledTests = [
    # RuntimeError: Event loop is closed
    "test_subscribe_no_echo"
    "test_publish"
    "test_publish_verbose"
    "test_fetch_max_waiting_fetch_one"
    "test_fetch_n"
    "test_consumer_management"
    "test_ephemeral_subscribe"
    "test_queue_subscribe_deliver_group"
    "test_subscribe_push_bound"
    "test_double_acking_subscribe"
    "test_flow_control"
    "test_ordered_consumer"
    "test_ordered_consumer_single_loss"
    "test_kv_simple"
  ];

  pythonImportsCheck = [
    "nats"
  ];

  meta = with lib; {
    description = "Python client for NATS.io";
    homepage = "https://github.com/nats-io/nats.py";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
