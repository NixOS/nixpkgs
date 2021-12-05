{ lib, stdenv, buildPythonPackage, fetchPypi, pythonOlder
# install_requires
, attrs, charset-normalizer, multidict, async-timeout, yarl, frozenlist
, aiosignal, aiodns, brotli, cchardet, asynctest, typing-extensions, idna-ssl
# tests_require
, async_generator, freezegun, gunicorn, pytest-mock, pytestCheckHook, re-assert
, trustme }:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-07GdjRg7z9aLJb7rq43DMIKC/iyj1uo8tM0QGzwnn40=";
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
  ] ++ lib.optionals (pythonOlder "3.8") [ asynctest typing-extensions ]
    ++ lib.optionals (pythonOlder "3.7") [ idna-ssl ];

  checkInputs = [
    async_generator
    freezegun
    gunicorn
    pytest-mock
    pytestCheckHook
    re-assert
    trustme
  ];

  disabledTests = [
    # Disable tests that require network access
    "test_client_session_timeout_zero"
    "test_mark_formdata_as_processed"
    "test_requote_redirect_url_default"
  ] ++ lib.optionals stdenv.is32bit [ "test_cookiejar" ]
    ++ lib.optionals stdenv.isDarwin [
      "test_addresses" # https://github.com/aio-libs/aiohttp/issues/3572, remove >= v4.0.0
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
  '';

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = "https://github.com/aio-libs/aiohttp";
    maintainers = with maintainers; [ dotlambda ];
  };
}
