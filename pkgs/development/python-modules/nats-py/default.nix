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
  version = "2.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-5lvdt1JbOmdts0CYU00bSmv0LsMQsOe//yUgyevBULE=";
  };

  build-system = [ setuptools ];

  dependencies = [ ed25519 ];

  passthru.optional-dependencies = {
    aiohttp = [ aiohttp ];
    nkeys = [ nkeys ];
    # fast_parse = [
    #   fast-mail-parser
    # ];
  };

  nativeCheckInputs = [
    nats-server
    pytestCheckHook
    uvloop
  ];

  disabledTests =
    [
      # AssertionError: assert 5 == 0
      "test_pull_subscribe_limits"
      "test_fetch_n"
      "test_subscribe_no_echo"
      "test_stream_management"
      # Tests fail on hydra, often Time-out
      "test_subscribe_iterate_next_msg"
      "test_ordered_consumer_larger_streams"
      "test_object_file_basics"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "test_subscribe_iterate_next_msg"
      "test_buf_size_force_flush_timeout"
    ];

  pythonImportsCheck = [ "nats" ];

  meta = with lib; {
    description = "Python client for NATS.io";
    homepage = "https://github.com/nats-io/nats.py";
    changelog = "https://github.com/nats-io/nats.py/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
