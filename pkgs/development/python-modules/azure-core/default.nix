{ lib, buildPythonPackage, fetchPypi, isPy27
, aiodns
, aiohttp
, mock
, msrest
, pytest
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, requests
, six
, trio
, typing-extensions
}:

buildPythonPackage rec {
  version = "1.8.2";
  pname = "azure-core";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "621b53271f7988b766f8a7d7f7a2c44241e3d2c1d8db13e68089d6da6241748e";
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
    pytest-trio
    pytest-asyncio
    pytestCheckHook
    trio
    typing-extensions
  ];

  pytestFlagsArray = [ "tests/" ];
  # disable tests which touch network
  disabledTests = [ "aiohttp" "multipart_send" "response" "request" "timeout" ];

  meta = with lib; {
    description = "Microsoft Azure Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
