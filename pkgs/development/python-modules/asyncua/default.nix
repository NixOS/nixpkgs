{
  lib,
  stdenv,
  aiofiles,
  aiosqlite,
  anyio,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  pyopenssl,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  pytz,
  sortedcontainers,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "asyncua";
  version = "2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-asyncio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mJ4ZUKx4zuprpH6FUrw7MLkekX0RDnzkJscQ4XC7tHE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Workaround hardcoded paths in test
    # "test_cli_tools_which_require_sigint"
    substituteInPlace tests/test_tools.py \
      --replace-fail "tools/" "$out/bin/"
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiofiles
    aiosqlite
    anyio
    cryptography
    pyopenssl
    python-dateutil
    pytz
    sortedcontainers
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pythonImportsCheck = [ "asyncua" ];

  # PermissionError: [Errno 1] Operation not permitted
  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # Failed: DID NOT RAISE <class 'asyncio.exceptions.TimeoutError'>
    "test_publish"
    # KeyError: 'Simple'
    "test_full_simple"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # dbm.sqlite3.error: SQLite objects created in a thread can only be used in that same thread.
    # The object was created in thread id 140737220687552 and this is thread id 140737343690560.
    "test_runTest"
    # error while attempting to bind on address
    "test_failover_warm"
    "test_client_admin"
    "test_client_user"
    "test_client_anonymous"
    "test_x509identity_user"
    "test_x509identity_anonymous"
    "test_client_user_x509identity_admin"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/test_callback_service.py"
    "tests/test_client_cert_chain.py"
    "tests/test_crypto_connect.py"
    "tests/test_crypto_connect.py"
    "tests/test_gen_certificates.py"
    "tests/test_password.py"
    "tests/test_permissions.py"
    "tests/test_pubsub.py"
    "tests/test_sync.py"
    "tests/test_truststore.py"
    "tests/test_subscriptions.py"
  ];

  meta = {
    description = "OPC UA / IEC 62541 Client and Server for Python";
    homepage = "https://github.com/FreeOpcUa/opcua-asyncio";
    changelog = "https://github.com/FreeOpcUa/opcua-asyncio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ harvidsen ];
  };
})
