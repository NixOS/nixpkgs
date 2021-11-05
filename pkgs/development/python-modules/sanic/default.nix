{ lib
, stdenv
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
  version = "21.9.1";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TRrJr/L8AXLAARPjhBi2FxNh+jvxxdeMN24cT1njmqY=";
  };

  postPatch = ''
    # Loosen dependency requirements.
    substituteInPlace setup.py \
      --replace '"pytest==6.2.5"' '"pytest"' \
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
    pytest-sugar
    pytestCheckHook
    sanic-testing
    uvicorn
  ];

  inherit doCheck;

  preCheck = ''
    # Some tests depends on executables on PATH
    PATH="$out/bin:${gunicorn}/bin:$PATH"
  '';

  disabledTests = [
    # Tests are flaky
    "test_keep_alive_client_timeout"
    "test_check_timeouts_request_timeout"
    "test_check_timeouts_response_timeout"
    "test_reloader_live"
    "test_zero_downtime"
    # Not working from 21.9.1
    "test_create_server_main"
    "test_create_server_main_convenience"
    "test_debug"
    "test_auto_reload"
  ] ++ lib.optionals stdenv.isDarwin [
    # https://github.com/sanic-org/sanic/issues/2298
    "test_no_exceptions_when_cancel_pending_request"
  ];

  # avoid usage of nixpkgs-review in darwin since tests will compete usage
  # for the same local port
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "sanic" ];

  meta = with lib; {
    description = "Web server and web framework";
    homepage = "https://github.com/sanic-org/sanic/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc AluisioASG ];
  };
}
