{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  pythonOlder,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,
  uv-dynamic-versioning,

  # dependencies
  anyio,
  certifi,
  httpcore2,
  idna,

  # optional dependencies
  brotli,
  brotlicffi,
  click,
  h2,
  pygments,
  rich,
  socksio,
  wsproto,
  zstandard,

  # tests
  chardet,
  pytestCheckHook,
  pytest-trio,
  starlette,
  trustme,
  uvicorn,
  websockets,

  # reverse deps
  httpx2,
}:

buildPythonPackage (finalAttrs: {
  pname = "httpx2";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "httpx2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3kghDQMYksF9a4sFGajzNfGPOjdX1OiMwv7rH/fbmM0=";
  };

  postPatch = ''
    pushd src/httpx2
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
    uv-dynamic-versioning
  ];

  dependencies = [
    anyio
    certifi
    httpcore2
    idna
  ];

  optional-dependencies = {
    brotli = if isPyPy then [ brotlicffi ] else [ brotli ];
    cli = [
      click
      pygments
      rich
    ];
    http2 = [ h2 ];
    socks = [ socksio ];
    ws = [ wsproto ];
    zstd = lib.optionals (pythonOlder "3.14") [ zstandard ];
  };

  pythonImportsCheck = [
    "httpx2"
  ];

  preCheck = ''
    popd
  '';

  nativeCheckInputs = [
    chardet
    pytestCheckHook
    pytest-trio
    (starlette.overridePythonAttrs { doCheck = false; })
    trustme
    uvicorn
    websockets
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [ "tests/httpx2" ];

  disabledTests = [
    # network access
    "test_async_proxy_close"
    "test_sync_proxy_close"
    # uvicorn access logging mismatch
    "test_logging_request"
    "test_logging_redirect_chain"
    # chardet shenanigans (Windows-1252 == WINDOWS-1252 cmp)
    "test_client_decode_text_using_autodetect"
    "test_client_decode_text_using_explicit_encoding"
    "test_response_decode_text_using_autodetect"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # TODO?
    "test_keepalive_ping"
  ];

  passthru.tests = {
    inherit httpx2;
  };

  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;

  meta = {
    description = "A next generation HTTP client for Python";
    homepage = "https://github.com/pydantic/httpx2";
    changelog = "https://github.com/pydantic/httpx2/blob/${finalAttrs.src.tag}/src/httpx2/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
