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
  version = "1.5.0";
  pname = "azure-core";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "181iyigm11y56lf1kwv7pcdyppavpwjb1b6k3qp3jnbqaypad9mg";
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
