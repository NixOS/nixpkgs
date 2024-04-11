{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, substituteAll
, llhttp
# build_requires
, cython
, setuptools
# install_requires
, attrs
, multidict
, async-timeout
, yarl
, frozenlist
, aiosignal
, aiodns
, brotli
# tests_require
, freezegun
, gunicorn
, pytest-mock
, pytestCheckHook
, pytest_7
, python-on-whales
, re-assert
, trustme
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.9.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp";
    rev = "refs/tags/v${version}";
    hash = "sha256-dEeMHruFJ1o0J6VUJcpUk7LhEC8sV8hUKXoKcd618lE=";
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

  nativeBuildInputs = [
    cython
    setuptools
  ];

  preBuild = ''
    make cythonize
  '';

  propagatedBuildInputs = [
    attrs
    multidict
    async-timeout
    yarl
    frozenlist
    aiosignal
    aiodns
    brotli
  ];

  # NOTE: pytest-xdist cannot be added because it is flaky. See https://github.com/NixOS/nixpkgs/issues/230597 for more info.
  nativeCheckInputs = [
    freezegun
    gunicorn
    pytest-mock
    (pytestCheckHook.override { pytest = pytest_7; })
    python-on-whales
    re-assert
  ] ++ lib.optionals (!(stdenv.isDarwin && stdenv.isAarch64)) [
    # Optional test dependency. Depends indirectly on pyopenssl, which is
    # broken on aarch64-darwin.
    trustme
  ];

  disabledTests = [
    # Disable tests that require network access
    "test_client_session_timeout_zero"
    "test_mark_formdata_as_processed"
    "test_requote_redirect_url_default"
    # Disable tests that trigger deprecation warnings in pytest
    "test_async_with_session"
    "test_session_close_awaitable"
    "test_close_run_until_complete_not_deprecated"
    # https://github.com/aio-libs/aiohttp/issues/7130
    "test_static_file_if_none_match"
    "test_static_file_if_match"
    "test_static_file_if_modified_since_past_date"
    # don't run benchmarks
    "test_import_time"
  ] ++ lib.optionals stdenv.is32bit [
    "test_cookiejar"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_addresses"  # https://github.com/aio-libs/aiohttp/issues/3572, remove >= v4.0.0
    "test_close"
  ];

  disabledTestPaths = [
    "tests/test_proxy_functional.py" # FIXME package proxy.py
  ];

  __darwinAllowLocalNetworking = true;

  # aiohttp in current folder shadows installed version
  preCheck = ''
    rm -r aiohttp
    touch tests/data.unknown_mime_type # has to be modified after 1 Jan 1990
  '' + lib.optionalString stdenv.isDarwin ''
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
