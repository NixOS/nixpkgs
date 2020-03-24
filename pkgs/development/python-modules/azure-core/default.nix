{ lib, buildPythonPackage, fetchPypi, isPy27
, aiodns
, aiohttp
, mock
, msrest
, pytest
, pytestCheckHook
, requests
, six
, trio
, typing-extensions
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "azure-core";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "98d03a35845fe5b6abaa32f5961214da3e16c4c82b8c601926fc5e7f3a39549e";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  checkInputs = [
    aiodns
    aiohttp
    mock
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
