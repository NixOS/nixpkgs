{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  ed25519,
  fetchFromGitHub,
  nats-server,
  nkeys,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  uvloop,
}:

buildPythonPackage rec {
  pname = "nats-py";
  version = "2.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.py";
    tag = "v${version}";
    hash = "sha256-wILjBhdlNU8U2lyJm4CmPy4DzOjJ7cBIkawKwW5KVgg=";
  };

  build-system = [ setuptools ];

  dependencies = [ ed25519 ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    nkeys = [ nkeys ];
    # fast_parse = [ fast-mail-parser ];
  };

  nativeCheckInputs = [
    nats-server
    pytestCheckHook
    uvloop
  ];

  disabledTests = [
    # Timeouts
    "ClientTLS"
    # AssertionError
    "test_fetch_n"
    "test_kv_simple"
    "test_pull_subscribe_limits"
    "test_stream_management"
    "test_subscribe_no_echo"
    # Tests fail on hydra, often Time-out
    "test_subscribe_iterate_next_msg"
    "test_ordered_consumer_larger_streams"
    "test_object_file_basics"
    # Should be safe to remove on next version upgrade (from 2.11.0)
    # https://github.com/nats-io/nats.py/pull/728
    "test_object_list"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_subscribe_iterate_next_msg"
    "test_buf_size_force_flush_timeout"
  ];

  pythonImportsCheck = [ "nats" ];

  meta = with lib; {
    description = "Python client for NATS.io";
    homepage = "https://github.com/nats-io/nats.py";
    changelog = "https://github.com/nats-io/nats.py/releases/tag/${src.tag}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
