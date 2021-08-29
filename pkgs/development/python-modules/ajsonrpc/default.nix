{ lib, pythonOlder, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "ajsonrpc";
  version = "1.1.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b5r8975wdnk3qnc1qjnn4lkxmqcir3brbwnxml9ii90dnsw408a";
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
