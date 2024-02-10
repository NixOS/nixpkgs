{ lib
, stdenv
, aiofiles
, aiosqlite
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pyopenssl
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, setuptools
, sortedcontainers
, typing-extensions
}:

buildPythonPackage rec {
  pname = "asyncua";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-16OzTxYafK1a/WVH46bL7VhxNI+XpkPHi2agbArpHUk=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # https://github.com/FreeOpcUa/opcua-asyncio/issues/1263
    substituteInPlace setup.py \
      --replace ", 'asynctest'" ""

    # Workaround hardcoded paths in test
    # "test_cli_tools_which_require_sigint"
    substituteInPlace tests/test_tools.py \
      --replace "tools/" "$out/bin/"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "asyncua"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Failed: DID NOT RAISE <class 'asyncio.exceptions.TimeoutError'>
    "test_publish"
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
    changelog = "https://github.com/FreeOpcUa/opcua-asyncio/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ harvidsen ];
  };
}
