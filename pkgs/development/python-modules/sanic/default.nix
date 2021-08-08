{ lib
, aiofiles
, beautifulsoup4
, buildPythonPackage
, doCheck ? true
, fetchFromGitHub
, fetchpatch
, gunicorn
, httptools
, multidict
, pytest-asyncio
, pytest-benchmark
, pytest-sanic
, pytest-sugar
, pytestCheckHook
, sanic-routing
, sanic-testing
, ujson
, uvicorn
, uvloop
, websockets
}:

buildPythonPackage rec {
  pname = "sanic";
  version = "21.3.4";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vldlic8gqcf56fqb31igycqf11syd9csk66v34w6dim54lcny2b";
  };

  patches = [
    # Allow later websockets release, https://github.com/sanic-org/sanic/pull/2154
    (fetchpatch {
      name = "later-websockets.patch";
      url = "https://github.com/sanic-org/sanic/commit/5fb820b5c1ce395e86a1ee11996790c65ec7bc65.patch";
      sha256 = "1glvq23pf1sxqjnrz0w8rr7nsnyz82k1479b3rm8szfkjg9q5d1w";
    })
  ];

  postPatch = ''
    # Loosen dependency requirements.
    substituteInPlace setup.py \
      --replace '"pytest==5.2.1"' '"pytest"' \
      --replace '"gunicorn==20.0.4"' '"gunicorn"' \
      --replace '"pytest-sanic",' "" \
    # Patch a request headers test to allow brotli encoding
    # (we build httpx with brotli support, upstream doesn't).
    substituteInPlace tests/test_headers.py \
      --replace "deflate\r\n" "deflate, br\r\n"
  '';

  propagatedBuildInputs = [
    aiofiles
    httptools
    multidict
    sanic-routing
    ujson
    uvloop
    websockets
  ];

  checkInputs = [
    beautifulsoup4
    gunicorn
    pytest-asyncio
    pytest-benchmark
    pytest-sanic
    pytest-sugar
    pytestCheckHook
    sanic-testing
    uvicorn
  ];

  inherit doCheck;

  disabledTests = [
    # Tests are flaky
    "test_keep_alive_client_timeout"
    "test_check_timeouts_request_timeout"
    "test_check_timeouts_response_timeout"
    "test_reloader_live"
    "test_zero_downtime"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "sanic" ];

  meta = with lib; {
    description = "Web server and web framework";
    homepage = "https://github.com/sanic-org/sanic/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc AluisioASG ];
  };
}
