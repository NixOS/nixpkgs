{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
# install_requires
, attrs
, charset-normalizer
, multidict
, async-timeout
, yarl
, frozenlist
, aiosignal
, aiodns
, brotli
, cchardet
, asynctest
, typing-extensions
, idna-ssl
# tests_require
, async_generator
, freezegun
, gunicorn
, pytest-mock
, pytestCheckHook
, re-assert
, trustme
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.8.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578";
  };

  postPatch = ''
    sed -i '/--cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    attrs
    charset-normalizer
    multidict
    async-timeout
    yarl
    typing-extensions
    frozenlist
    aiosignal
    aiodns
    brotli
    cchardet
  ] ++ lib.optionals (pythonOlder "3.8") [
    asynctest
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.7") [
    idna-ssl
  ];

  checkInputs = [
    async_generator
    freezegun
    gunicorn
    pytest-mock
    pytestCheckHook
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
  ] ++ lib.optionals stdenv.is32bit [
    "test_cookiejar"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_addresses"  # https://github.com/aio-libs/aiohttp/issues/3572, remove >= v4.0.0
    "test_close"
  ];

  disabledTestPaths = [
    "test_proxy_functional.py" # FIXME package proxy.py
  ];

  __darwinAllowLocalNetworking = true;

  # aiohttp in current folder shadows installed version
  # Probably because we run `python -m pytest` instead of `pytest` in the hook.
  preCheck = ''
    cd tests
  '' + lib.optionalString stdenv.isDarwin ''
    # Work around "OSError: AF_UNIX path too long"
    export TMPDIR="/tmp"
   '';

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = "https://github.com/aio-libs/aiohttp";
    maintainers = with maintainers; [ dotlambda ];
  };
}
