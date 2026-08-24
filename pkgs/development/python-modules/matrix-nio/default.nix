{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

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
  vodozemac,

  # tests
  aioresponses,
  faker,
  hpack,
  hyperframe,
  hypothesis,
  pytest-aiohttp,
  pytest-asyncio_0,
  pytest-benchmark,
  pytestCheckHook,

  # passthru tests
  nixosTests,
  opsdroid,
  pantalaimon,
  weechatScripts,
  zulip,

  withVodozemac ? false,
}:

buildPythonPackage rec {
  pname = "matrix-nio";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    tag = version;
    hash = "sha256-bypPBVArN+UnS4Zje603CgJspQsirgkkIHm6juwRigc=";
  };

  patches = [
    # Ignore olm import failures when testing
    ./allow-tests-without-olm.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    aiohttp-socks
    h11
    h2
    jsonschema
    pycryptodome
    unpaddedbase64
  ]
  ++ lib.optionals withVodozemac optional-dependencies.e2e;

  optional-dependencies = {
    e2e = [
      atomicwrites
      cachetools
      vodozemac
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
    (pytest-aiohttp.override { pytest-asyncio = pytest-asyncio_0; })
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  disabledTestPaths = lib.optionals (!withVodozemac) [
    "tests/encryption_test.py"
    "tests/key_export_test.py"
    "tests/memory_store_test.py"
    "tests/sas_test.py"
    "tests/sessions_test.py"
    "tests/store_test.py"
  ];

  disabledTests = [
    # touches network
    "test_connect_wrapper"
    # time dependent and flaky
    "test_transfer_monitor_callbacks"
    # _plain_data_generator yields str but test expects bytes
    "test_upload_retry"
    "test_upload_text_file_object"
  ]
  ++ lib.optionals (!withVodozemac) [
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

  meta = {
    homepage = "https://github.com/poljar/matrix-nio";
    changelog = "https://github.com/poljar/matrix-nio/blob/${version}/CHANGELOG.md";
    description = "Python Matrix client library, designed according to sans I/O principles";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      tilpner
      symphorien
    ];
  };
}
