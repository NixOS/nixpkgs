{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    sha256 = "1cd83m831ngck2v8m08pb2g29z4vr9iggi73l7h506v6clkb4n3y";
  };

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  meta = with lib; {
    description = "A JSON-RPC client library base interface";
    homepage = "https://github.com/emlove/jsonrpc-base";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
