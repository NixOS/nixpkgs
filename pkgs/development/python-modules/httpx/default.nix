{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, brotlicffi
, certifi
, charset-normalizer
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
  version = "0.19.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-bUxxeUYqOHBmSL2gPQG5cIq6k5QY4Kyhj9ToA5yZXPA=";
  };

  propagatedBuildInputs = [
    brotlicffi
    certifi
    charset-normalizer
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
