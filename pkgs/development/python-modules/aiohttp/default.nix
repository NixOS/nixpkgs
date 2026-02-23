{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  isPyPy,
  pythonOlder,

  # build-system
  cython,
  pkgconfig,
  setuptools,

  # native dependencies
  llhttp,

  # dependencies
  aiohappyeyeballs,
  aiosignal,
  async-timeout,
  attrs,
  backports-zstd,
  frozenlist,
  multidict,
  propcache,
  yarl,

  # optional dependencies
  aiodns,
  brotli,
  brotlicffi,

  # tests
  blockbuster,
  freezegun,
  gunicorn,
  isa-l,
  isal,
  proxy-py,
  pytest-codspeed,
  pytest-cov-stub,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  re-assert,
  trustme,
  zlib-ng,
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp";
    tag = "v${version}";
    hash = "sha256-V+digrfigdA3hwd2xW47BACh3r07j6pGE8WFAGivZnA=";
  };

  postPatch = ''
    rm -r vendor
    patchShebangs tools
    touch .git  # tools/gen.py uses .git to find the project root

    # don't install Cython using pip
    substituteInPlace Makefile \
      --replace-fail "cythonize: .install-cython" "cythonize:"
  '';

  build-system = [
    cython
    pkgconfig
    setuptools
  ];

  preBuild = ''
    make cythonize
  '';

  buildInputs = [
    llhttp
  ];

  env.AIOHTTP_USE_SYSTEM_DEPS = true;

  dependencies = [
    aiohappyeyeballs
    aiosignal
    attrs
    frozenlist
    multidict
    propcache
    yarl
  ]
  ++ optional-dependencies.speedups;

  optional-dependencies.speedups = [
    aiodns
    (if isPyPy then brotlicffi else brotli)
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    backports-zstd
  ];

  nativeCheckInputs = [
    blockbuster
    freezegun
    gunicorn
    # broken on aarch64-darwin
    (if lib.meta.availableOn stdenv.hostPlatform isa-l then isal else null)
    proxy-py
    pytest-codspeed
    pytest-cov-stub
    pytest-mock
    pytest-xdist
    pytestCheckHook
    re-assert
    trustme
    zlib-ng
  ];

  disabledTests = [
    # Disable tests that require network access
    "test_client_session_timeout_zero"
    "test_mark_formdata_as_processed"
    "test_requote_redirect_url_default"
    "test_tcp_connector_ssl_shutdown_timeout_nonzero_passed"
    "test_tcp_connector_ssl_shutdown_timeout_zero_not_passed"
    "test_invalid_idna"
    # don't run benchmarks
    "test_import_time"
    # racy
    "test_uvloop_secure_https_proxy"
    # Cannot connect to host example.com:443 ssl:default [Could not contact DNS servers]
    "test_tcp_connector_ssl_shutdown_timeout_passed_to_create_connection"
  ]
  ++ lib.optionals stdenv.hostPlatform.is32bit [ "test_cookiejar" ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_addresses" # https://github.com/aio-libs/aiohttp/issues/3572, remove >= v4.0.0
    "test_close"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # aiohttp in current folder shadows installed version
    rm -r aiohttp
    touch tests/data.unknown_mime_type # has to be modified after 1 Jan 1990

    export HOME=$(mktemp -d)
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Work around "OSError: AF_UNIX path too long"
    export TMPDIR="/tmp"
  '';

  meta = {
    changelog = "https://docs.aiohttp.org/en/${src.tag}/changes.html";
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = lib.licenses.asl20;
    homepage = "https://github.com/aio-libs/aiohttp";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
