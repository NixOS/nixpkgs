{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiofiles,
  aiohttp,
  aiohttp-socks,
  h11,
  h2,
  jsonschema,
  pycryptodome,
  unpaddedbase64,

  # optional-dependencies
  atomicwrites,
  cachetools,
  peewee,
  python-olm,

  # tests
  aioresponses,
  faker,
  hpack,
  hyperframe,
  hypothesis,
  pytest-aiohttp,
  pytest-benchmark,
  pytestCheckHook,

  # passthru tests
  nixosTests,
  opsdroid,
  pantalaimon,
  weechatScripts,
  zulip,

  withOlm ? false,
}:

buildPythonPackage rec {
  pname = "matrix-nio";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = "refs/tags/${version}";
    hash = "sha256-wk1UjnazBdK4BCWXRG5Bn9Rasrk+yy3qqideS8tEAk8=";
  };

  patches = [
    # Ignore olm import failures when testing
    ./allow-tests-without-olm.patch
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    aiohttp
    aiohttp-socks
    h11
    h2
    jsonschema
    pycryptodome
    unpaddedbase64
  ] ++ lib.optionals withOlm optional-dependencies.e2e;

  optional-dependencies = {
    e2e = [
      atomicwrites
      cachetools
      python-olm
      peewee
    ];
  };

  pythonRelaxDeps = [
    "aiofiles"
    "aiohttp-socks" # Pending matrix-nio/matrix-nio#516
  ];

  nativeCheckInputs = [
    aioresponses
    faker
    hpack
    hyperframe
    hypothesis
    pytest-aiohttp
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  disabledTestPaths = lib.optionals (!withOlm) [
    "tests/encryption_test.py"
    "tests/key_export_test.py"
    "tests/memory_store_test.py"
    "tests/sas_test.py"
    "tests/sessions_test.py"
    "tests/store_test.py"
  ];

  disabledTests =
    [
      # touches network
      "test_connect_wrapper"
      # time dependent and flaky
      "test_transfer_monitor_callbacks"
    ]
    ++ lib.optionals (!withOlm) [
      "test_client_account_sharing"
      "test_client_key_query"
      "test_client_login"
      "test_client_protocol_error"
      "test_client_restore_login"
      "test_client_room_creation"
      "test_device_store"
      "test_e2e_sending"
      "test_early_store_loading"
      "test_encrypted_data_generator"
      "test_http_client_keys_query"
      "test_key_claiming"
      "test_key_exports"
      "test_key_invalidation"
      "test_key_sharing"
      "test_key_sharing_callbacks"
      "test_key_sharing_cancellation"
      "test_keys_query"
      "test_keys_upload"
      "test_marking_sessions_as_shared"
      "test_message_sending"
      "test_query_rule"
      "test_room_devices"
      "test_sas_verification"
      "test_sas_verification_cancel"
      "test_session_sharing"
      "test_session_sharing_2"
      "test_session_unwedging"
      "test_storing_room_encryption_state"
      "test_sync_forever"
      "test_sync_token_restoring"
    ];

  passthru.tests = {
    inherit (nixosTests)
      dendrite
      matrix-appservice-irc
      matrix-conduit
      mjolnir
      ;
    inherit (weechatScripts) weechat-matrix;
    inherit opsdroid pantalaimon zulip;
  };

  meta = with lib; {
    homepage = "https://github.com/poljar/matrix-nio";
    changelog = "https://github.com/poljar/matrix-nio/blob/${version}/CHANGELOG.md";
    description = "Python Matrix client library, designed according to sans I/O principles";
    license = licenses.isc;
    maintainers = with maintainers; [
      tilpner
      symphorien
    ];
  };
}
