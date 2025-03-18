{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  substituteAll,
  llhttp,
  python,
  # build_requires
  cython,
  setuptools,
  # install_requires
  aiohappyeyeballs,
  attrs,
  multidict,
  async-timeout,
  yarl,
  frozenlist,
  aiosignal,
  aiodns,
  brotli,
  # tests_require
  freezegun,
  gunicorn,
  proxy-py,
  pytest-mock,
  pytest7CheckHook,
  python-on-whales,
  re-assert,
  trustme,
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.10.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp";
    rev = "refs/tags/v${version}";
    hash = "sha256-jetgFHFD9l2hW7FWbGESM6Tqeav+2rM8C2TCV0bPJwU=";
  };

  patches = [
    (substituteAll {
      src = ./unvendor-llhttp.patch;
      llhttpDev = lib.getDev llhttp;
      llhttpLib = lib.getLib llhttp;
    })
  ];

  postPatch = ''
    sed -i '/--cov/d' setup.cfg

    rm -r vendor
    patchShebangs tools
    touch .git  # tools/gen.py uses .git to find the project root
  '';

  build-system = [
    cython
    setuptools
  ];

  preBuild = ''
    make cythonize
  '';

  dependencies = [
    aiohappyeyeballs
    attrs
    multidict
    async-timeout
    yarl
    frozenlist
    aiosignal
    aiodns
    brotli
  ];

  postInstall = ''
    # remove source code file with reference to dev dependencies
    rm $out/${python.sitePackages}/aiohttp/_cparser.pxd{,.orig}
  '';

  # NOTE: pytest-xdist cannot be added because it is flaky. See https://github.com/NixOS/nixpkgs/issues/230597 for more info.
  nativeCheckInputs = [
    freezegun
    gunicorn
    proxy-py
    pytest-mock
    pytest7CheckHook
    python-on-whales
    re-assert
    trustme
  ];

  disabledTests =
    [
      # Disable tests that require network access
      "test_client_session_timeout_zero"
      "test_mark_formdata_as_processed"
      "test_requote_redirect_url_default"
      # don't run benchmarks
      "test_import_time"
    ]
    ++ lib.optionals stdenv.is32bit [ "test_cookiejar" ]
    ++ lib.optionals stdenv.isDarwin [
      "test_addresses" # https://github.com/aio-libs/aiohttp/issues/3572, remove >= v4.0.0
      "test_close"
    ];

  __darwinAllowLocalNetworking = true;

  preCheck =
    ''
      # aiohttp in current folder shadows installed version
      rm -r aiohttp
      touch tests/data.unknown_mime_type # has to be modified after 1 Jan 1990

      export HOME=$(mktemp -d)
    ''
    + lib.optionalString stdenv.isDarwin ''
      # Work around "OSError: AF_UNIX path too long"
      export TMPDIR="/tmp"
    '';

  meta = with lib; {
    changelog = "https://github.com/aio-libs/aiohttp/blob/v${version}/CHANGES.rst";
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = "https://github.com/aio-libs/aiohttp";
    maintainers = with maintainers; [ dotlambda ];
  };
}
