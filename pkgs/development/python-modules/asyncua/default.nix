{ lib
, aiofiles
, aiosqlite
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, sortedcontainers
, typing-extensions
}:

buildPythonPackage rec {
  pname = "asyncua";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-DnBxR4nD3dBBhiElDuRgljHaoBPiakdjY/VFn3VsKEQ=";
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

  propagatedBuildInputs = [
    aiosqlite
    aiofiles
    pytz
    python-dateutil
    sortedcontainers
    cryptography
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

  meta = with lib; {
    description = "OPC UA / IEC 62541 Client and Server for Python";
    homepage = "https://github.com/FreeOpcUa/opcua-asyncio";
    changelog = "https://github.com/FreeOpcUa/opcua-asyncio/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ harvidsen ];
  };
}
