{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
# build_requires
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
, gunicorn
, pytest-mock
, pytestCheckHook
, python-on-whales
, re-assert
, time-machine
, trustme
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CfIyktKRNQJeGej/Twpo3weP5O4BO8oBBbLoA5id6S0=";
  };

  postPatch = ''
    sed -i '/--cov/d' setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
  ];

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
    gunicorn
    pytest-mock
    pytestCheckHook
    python-on-whales
    re-assert
    time-machine
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
