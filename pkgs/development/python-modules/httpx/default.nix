{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, brotlicffi
, certifi
, h2
, httpcore
, rfc3986
, sniffio
, pytestCheckHook
, pytest-asyncio
, pytest-trio
, typing-extensions
, trustme
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.18.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0rr5b6z96yipvp4riqmmbkbcy0sdyzykcdwf5y9ryh27pxr8q8x4";
  };

  propagatedBuildInputs = [
    brotlicffi
    certifi
    h2
    httpcore
    rfc3986
    sniffio
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-trio
    trustme
    typing-extensions
    uvicorn
  ];

  pythonImportsCheck = [ "httpx" ];

  disabledTests = [
    # httpcore.ConnectError: [Errno 101] Network is unreachable
    "test_connect_timeout"
    # httpcore.ConnectError: [Errno -2] Name or service not known
    "test_async_proxy_close"
    "test_sync_proxy_close"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "The next generation HTTP client";
    homepage = "https://github.com/encode/httpx";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc fab ];
  };
}
