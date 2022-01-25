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
, python
, pytestCheckHook
, pytest-asyncio
, pytest-trio
, typing-extensions
, trustme
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

  # testsuite wants to find installed packages for testing entrypoint
  preCheck = ''
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  disabledTests = [
    # httpcore.ConnectError: [Errno 101] Network is unreachable
    "test_connect_timeout"
    # httpcore.ConnectError: [Errno -2] Name or service not known
    "test_async_proxy_close"
    "test_sync_proxy_close"
    # sensitive to charset_normalizer output
    "iso-8859-1"
    "test_response_no_charset_with_iso_8859_1_content"
  ];

  disabledTestPaths = [
    "tests/test_main.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "The next generation HTTP client";
    homepage = "https://github.com/encode/httpx";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc fab ];
  };
}
