{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  nats-server,
  nkeys,
  pynacl,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
  uvloop,
}:

buildPythonPackage (finalAttrs: {
  pname = "nats-py";
  version = "2.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rs+C++g21dKZ6c7L5dJYqWSiv4J8qMGobW7R8icUfVw=";
  };

  sourceRoot = "${finalAttrs.src.name}/nats";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.28,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ pynacl ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    nkeys = [ nkeys ];
    # fast_parse = [ fast-mail-parser ];
  };

  nativeCheckInputs = [
    nats-server
    pytest-asyncio
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
    "test_rtt"
    # Tests fail on hydra, often Time-out
    "test_subscribe_iterate_next_msg"
    "test_ordered_consumer_larger_streams"
    "test_object_file_basics"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_subscribe_iterate_next_msg"
    "test_buf_size_force_flush_timeout"
  ];

  pythonImportsCheck = [ "nats" ];

  meta = {
    description = "Python client for NATS.io";
    homepage = "https://github.com/nats-io/nats.py";
    changelog = "https://github.com/nats-io/nats.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
