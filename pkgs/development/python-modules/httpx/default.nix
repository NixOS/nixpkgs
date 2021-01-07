{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, brotli
, certifi
, h2
, httpcore
, rfc3986
, sniffio
, pytestCheckHook
, pytest-asyncio
, pytest-trio
, pytestcov
, trustme
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.16.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "00gmq45fckcqkj910bvd7pyqz1mvgsdvz4s0k7dzbnc5czzq1f4a";
  };

  propagatedBuildInputs = [
    brotli
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
    pytestcov
    trustme
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
    maintainers = [ maintainers.costrouc ];
  };
}
