{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, jsonrpc-base
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonrpc-async";
<<<<<<< HEAD
  version = "2.1.2";
=======
  version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-KOnycsOZFDEVj8CJDwGbdtbOpMPQMVdrXbHG0fzr9PI=";
=======
    hash = "sha256-HhesXzxVjhWJkubiBi6sMoXi/zicqn99dqT5bilycS8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-base
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "jsonrpc_async"
  ];

  meta = with lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-async";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
