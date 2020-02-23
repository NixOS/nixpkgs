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
  version = "1.2.2";
  pname = "azure-core";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0bz4m6kmqymxlxf9qk6jw8v895d13rsggbgsjpsbvi9px6w15nwb";
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
