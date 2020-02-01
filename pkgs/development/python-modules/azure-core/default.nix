{ lib, buildPythonPackage, fetchPypi, isPy27
, aiodns
, aiohttp
, msrest
, pytest
, pytestCheckHook
, requests
, six
, trio
, typing-extensions
}:

buildPythonPackage rec {
  version = "1.2.1";
  pname = "azure-core";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1fff6g5lszn97qz1h4l1n255r9538yybb329ilb2rwdfq3q9kkg2";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  checkInputs = [
    aiodns
    aiohttp
    msrest
    pytest
    pytestCheckHook
    trio
    typing-extensions
  ];

  pytestFlagsArray = [ "tests/" ];
  disabledTests = [ "response" "request" "timeout" ];

  meta = with lib; {
    description = "Microsoft Azure Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
