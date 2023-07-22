{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
# build_requires
, setuptools
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
, faust-cchardet
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
  version = "3.8.5";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uVUuxSzBR9vxlErHrJivdgLlHqLc0HbtGUyjwNHH0Lw=";
  };

  postPatch = ''
    sed -i '/--cov/d' setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
  ];

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
    faust-cchardet
  ] ++ lib.optionals (pythonOlder "3.8") [
    asynctest
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.7") [
    idna-ssl
  ];

  # NOTE: pytest-xdist cannot be added because it is flaky. See https://github.com/NixOS/nixpkgs/issues/230597 for more info.
  nativeCheckInputs = [
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
    changelog = "https://github.com/aio-libs/aiohttp/blob/v${version}/CHANGES.rst";
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = "https://github.com/aio-libs/aiohttp";
    maintainers = with maintainers; [ dotlambda ];
  };
}
