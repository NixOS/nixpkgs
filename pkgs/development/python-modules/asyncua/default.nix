{ lib
, buildPythonPackage
, fetchFromGitHub
, aiosqlite
, aiofiles
, pytz
, python-dateutil
, sortedcontainers
, cryptography
, typing-extensions
, importlib-metadata
, pytestCheckHook
, pytest-asyncio
, pytest-mock
, asynctest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncua";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-asyncio";
    rev = "v${version}";
    hash = "sha256-wBtI3ZlsvOkNvl/q0X9cm2hNRUBW1oB/kZOo8lqo4dQ=";
  };

  propagatedBuildInputs = [
    aiosqlite
    aiofiles
    pytz
    python-dateutil
    sortedcontainers
    cryptography
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  pythonImportsCheck = [
    "asyncua"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    asynctest
  ];

  disabledTests = [
    "test_cli_tools_which_require_sigint" # Hard coded path only works from root of src
  ];

  meta = with lib; {
    description = "OPC UA / IEC 62541 Client and Server for Python";
    homepage = "https://github.com/FreeOpcUa/opcua-asyncio";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ harvidsen ];
  };
}
