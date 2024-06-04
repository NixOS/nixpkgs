{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  beautifulsoup4,
  httpx,
  multidict,
  typer,
  yarl,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "authcaptureproxy";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alandtse";
    repo = "auth_capture_proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-gdu0Ror/epu6huTEpBrqHD62O9uaL6273pKnpqPKskc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    httpx
    multidict
    typer
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # test fails with frequency 1/200
    # https://github.com/alandtse/auth_capture_proxy/issues/25
    "test_return_timer_countdown_refresh_html"
  ];

  pythonImportsCheck = [ "authcaptureproxy" ];

  meta = with lib; {
    changelog = "https://github.com/alandtse/auth_capture_proxy/releases/tag/v${version}";
    description = "A proxy to capture authentication information from a webpage";
    mainProgram = "auth_capture_proxy";
    homepage = "https://github.com/alandtse/auth_capture_proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      graham33
      hexa
    ];
  };
}
