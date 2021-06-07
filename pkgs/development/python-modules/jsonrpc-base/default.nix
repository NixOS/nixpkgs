{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    sha256 = "0xxhn0vb7mr8k1w9xbqhhyx9qkgkc318qkyflgfbvjc926n50680";
  };

  checkInputs = [
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
