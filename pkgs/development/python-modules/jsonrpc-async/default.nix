{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, jsonrpc-base
, pytest-aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    sha256 = "1ff3523rwgira5llmf5iriwqag7b6ln9vmj0s70yyc6k98yg06rp";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  meta = with lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-async";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
