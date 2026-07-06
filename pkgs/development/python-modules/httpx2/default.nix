{
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
  zstandard,

  # tests
  chardet,
  pytestCheckHook,
  pytest-httpbin,
  pytest-trio,
  trustme,
  uvicorn,

  # reverse deps
  httpx2,
}:

buildPythonPackage (finalAttrs: {
  pname = "httpx2";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "httpx2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cW6meHx6VBMz5r/lXCKKK7Sq4e2nk+n1A5YTNtR2kB4=";
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
    # pytest-httpbin
    pytest-trio
    trustme
    uvicorn
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [ "tests/httpx2" ];

  disabledTests = [
    # network access
    "test_async_proxy_close"
    "test_sync_proxy_close"
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
