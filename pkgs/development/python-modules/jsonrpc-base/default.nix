{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    hash = "sha256-C03m/zeLIFqsmEMSzt84LMOWAHUcpdEHhaa5hx2NsoQ=";
  };

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "jsonrpc_base"
  ];

  meta = with lib; {
    description = "A JSON-RPC client library base interface";
    homepage = "https://github.com/emlove/jsonrpc-base";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
