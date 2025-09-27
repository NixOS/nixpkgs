{
  lib,
  stdenv,
  aiofiles,
  aiosqlite,
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

buildPythonPackage rec {
  pname = "asyncua";
  version = "1.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-asyncio";
    tag = "v${version}";
    hash = "sha256-0eay/NlWn0I2oF0fTln9/d4y31zGfAj9ph3bWkgd8Nk=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Workaround hardcoded paths in test
    # "test_cli_tools_which_require_sigint"
    substituteInPlace tests/test_tools.py \
      --replace-fail "tools/" "$out/bin/"

    # X.509 common name may become too long when including a real hostname
    # ValueError: Attribute's length must be >= 1 and <= 64, but it was 76
    substituteInPlace tests/test_truststore.py tests/test_gen_certificates.py \
      --replace-fail 'socket.gethostname()' '"fakehost"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiofiles
    aiosqlite
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

  disabledTestPaths =
    lib.optionals (pythonAtLeast "3.13") [
      # dbm.sqlite3.error: SQLite objects created in a thread can only be used in that same thread.
      # The object was created in thread id 140737220687552 and this is thread id 140737343690560.
      "tests/test_server.py::test_runTest"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # OSError: [Errno 48] error while attempting to bind on address ('127.0.0.1',...
      "tests/test_callback_service.py"
      "tests/test_crypto_connect.py"
      "tests/test_password.py"
      "tests/test_sync.py"
      # Failed: assert Client(opc.tcp://127.0.0.1:49441) != Client(opc.tcp://127.0.0.1:49441)
      "tests/test_ha_client.py::TestHaClient::test_failover_warm"
    ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "OPC UA / IEC 62541 Client and Server for Python";
    homepage = "https://github.com/FreeOpcUa/opcua-asyncio";
    changelog = "https://github.com/FreeOpcUa/opcua-asyncio/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ harvidsen ];
  };
}
