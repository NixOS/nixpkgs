{
  lib,
  stdenv,
  anyio,
  brotli,
  brotlicffi,
  buildPythonPackage,
  certifi,
  chardet,
  click,
  fetchFromGitHub,
  h2,
  hatch-fancy-pypi-readme,
  hatchling,
  httpcore,
  idna,
  isPyPy,
  multipart,
  pygments,
  python,
  pythonOlder,
  rich,
  socksio,
  pytestCheckHook,
  pytest-asyncio,
  pytest-trio,
  trustme,
  uvicorn,
  zstandard,
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.28.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "httpx";
    tag = version;
    hash = "sha256-tB8uZm0kPRnmeOvsDdrkrHcMVIYfGanB4l/xHsTKpgE=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    anyio
    certifi
    httpcore
    idna
  ];

  optional-dependencies = {
    brotli = if isPyPy then [ brotlicffi ] else [ brotli ];
    cli = [
      click
      rich
      pygments
    ];
    http2 = [ h2 ];
    socks = [ socksio ];
    zstd = [ zstandard ];
  };

  # trustme uses pyopenssl
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  nativeCheckInputs = [
    chardet
    multipart
    pytestCheckHook
    pytest-asyncio
    pytest-trio
    trustme
    uvicorn
  ]
  ++ lib.concatAttrValues optional-dependencies;

  # testsuite wants to find installed packages for testing entrypoint
  preCheck = ''
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    "-Wignore::trio.TrioDeprecationWarning"
  ];

  disabledTests = [
    # httpcore.ConnectError: [Errno 101] Network is unreachable
    "test_connect_timeout"
    # httpcore.ConnectError: [Errno -2] Name or service not known
    "test_async_proxy_close"
    "test_sync_proxy_close"
    # ResourceWarning: Async generator 'httpx._content.ByteStream.__aiter__' was garbage collected before it had been exhausted. Surround its use in 'async with aclosing(...):' to ensure that it gets cleaned up as soon as you're done using it.
    "test_write_timeout" # trio variant
  ];

  disabledTestPaths = [ "tests/test_main.py" ];

  pythonImportsCheck = [ "httpx" ];

  __darwinAllowLocalNetworking = true;

  # stdenv's fake SSL_CERT_FILE breaks default http transport constructor with:
  # FileNotFoundError: [Errno 2] No such file or directory
  setupHook = ./setup-hook.sh;

  meta = with lib; {
    changelog = "https://github.com/encode/httpx/blob/${src.rev}/CHANGELOG.md";
    description = "Next generation HTTP client";
    mainProgram = "httpx";
    homepage = "https://github.com/encode/httpx";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
