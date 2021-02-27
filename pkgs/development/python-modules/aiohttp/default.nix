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
, pytest-xdist
, pytestCheckHook
, re-assert
, trustme
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.7.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pn79h8fng4xi5gl1f6saw31nxgmgyxl41yf3vba1l21673yr12x";
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
    pytest-xdist
    pytestCheckHook
    re-assert
    trustme
  ];

  pytestFlagsArray = [
    "-n auto"
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
