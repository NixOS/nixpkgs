{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, async-timeout
, attrs
, chardet
, idna-ssl
, multidict
, typing-extensions
, yarl
, async_generator
, brotlipy
, freezegun
, gunicorn
, pytest-mock
, pytestCheckHook
, re-assert
, trustme
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.7.4.post0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "493d3299ebe5f5a7c66b9819eacdcfbbaaf1a8e84911ddffcdc48888497afecf";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace " --cov=aiohttp" ""
  '';

  propagatedBuildInputs = [
    async-timeout
    attrs
    chardet
    multidict
    typing-extensions
    yarl
  ] ++ lib.optionals (pythonOlder "3.7") [
    idna-ssl
  ];

  checkInputs = [
    async_generator
    brotlipy
    freezegun
    gunicorn
    pytest-mock
    pytestCheckHook
    re-assert
    trustme
  ];

  disabledTests = [
    # Disable tests that require network access
    "test_mark_formdata_as_processed"
  ] ++ lib.optionals stdenv.is32bit [
    "test_cookiejar"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_addresses"  # https://github.com/aio-libs/aiohttp/issues/3572, remove >= v4.0.0
    "test_close"
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
