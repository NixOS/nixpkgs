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
  pythonOlder,
  pytz,
  sortedcontainers,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "asyncua";
  version = "1.1.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  disabledTests = [
    # Failed: DID NOT RAISE <class 'asyncio.exceptions.TimeoutError'>
    "test_publish"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # dbm.sqlite3.error: SQLite objects created in a thread can only be used in that same thread.
    # The object was created in thread id 140737220687552 and this is thread id 140737343690560.
    "test_runTest"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # OSError: [Errno 48] error while attempting to bind on address ('127.0.0.1',...
    "test_anonymous_rejection"
    "test_certificate_handling_success"
    "test_encrypted_private_key_handling_success"
    "test_encrypted_private_key_handling_success_with_cert_props"
    "test_encrypted_private_key_handling_failure"
  ];

  meta = with lib; {
    description = "OPC UA / IEC 62541 Client and Server for Python";
    homepage = "https://github.com/FreeOpcUa/opcua-asyncio";
    changelog = "https://github.com/FreeOpcUa/opcua-asyncio/releases/tag/${src.tag}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ harvidsen ];
  };
}
