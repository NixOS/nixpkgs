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
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-6A4z+tiQ2oUlB9t44wlW64j5sjWFMAgqT3Xt0FdJCBs=";
  };

  postPatch = ''
    # https://github.com/FreeOpcUa/opcua-asyncio/issues/1263
    substituteInPlace setup.py \
      --replace ", 'asynctest'" ""
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

  disabledTests = [
    # Hard coded path only works from root of src
    "test_cli_tools_which_require_sigint"
  ];

  meta = with lib; {
    description = "OPC UA / IEC 62541 Client and Server for Python";
    homepage = "https://github.com/FreeOpcUa/opcua-asyncio";
    changelog = "https://github.com/FreeOpcUa/opcua-asyncio/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ harvidsen ];
  };
}
