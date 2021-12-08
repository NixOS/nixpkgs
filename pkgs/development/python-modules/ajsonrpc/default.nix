{ lib, pythonOlder, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "ajsonrpc";
  version = "1.2.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
     owner = "pavlov99";
     repo = "ajsonrpc";
     rev = "1.2.0";
     sha256 = "0c7jxfkv5q2m95j54dn650gcvdbpag2qcki7phvmrwsgb36w09kd";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ajsonrpc" ];

  meta = with lib; {
    description = "Async JSON-RPC 2.0 protocol + asyncio server";
    homepage = "https://github.com/pavlov99/ajsonrpc";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
