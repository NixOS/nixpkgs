{ lib
, brotlicffi
, buildPythonPackage
, certifi
, charset-normalizer
, click
, fetchFromGitHub
, h2
, httpcore
, pygments
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, pythonOlder
, rfc3986
, rich
, sniffio
, trustme
, typing-extensions
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.21.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-ayhLP+1hPWAx2ds227CKp5cebVkD5B2Z59L+3dzdINc=";
  };

  propagatedBuildInputs = [
    brotlicffi
    certifi
    charset-normalizer
    click
    h2
    httpcore
    pygments
    rfc3986
    rich
    sniffio
  ];

  checkInputs = [
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    trustme
    typing-extensions
    uvicorn
  ];

  pythonImportsCheck = [
    "httpx"
  ];

  disabledTestPaths = [
    # Tests fail with AssertionError: assert ['HTTP/1.1 30...
    "tests/test_main.py"
  ];

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
