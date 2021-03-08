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
, fetchpatch
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.7.4.post0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "493d3299ebe5f5a7c66b9819eacdcfbbaaf1a8e84911ddffcdc48888497afecf";
  };

  patches = [
    # Release all forgotten resources in tests
    # https://github.com/aio-libs/aiohttp/commit/405766156a79c9b441049a0bcbc4b0e1ecdc164d
    (fetchpatch {
      url = "https://github.com/aio-libs/aiohttp/commit/405766156a79c9b441049a0bcbc4b0e1ecdc164d.patch";
      excludes = [
        "tests/test_web_functional.py"
        "tests/test_client_session.py"
      ];
      sha256 = "12jdnrahp6sqxyyg5sj8478cpqwdfm5yqvsyh3cjvkpfaqdn73ni";
    })
    ./release-forgotten-ressources-backport.patch

    # https://github.com/aio-libs/aiohttp/commit/942c1b801f0ce4b5cd0103be58eb0359edf698a2
    ./pytest-ignore-resource-warnings.patch
  ];

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
    # AttributeError: 'Request' object has no attribute '_finish'
    "test_remote_peername_unix"
    # Exception ignored in: <function BaseConnector.__del__ at 0x7ffff53bb430>
    "test_connect_with_limit_cancelled"
    # NameError: name 'conn' is not defined
    "test_connect_with_capacity_release_waiters"
  ] ++ lib.optionals stdenv.is32bit [
    "test_cookiejar"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_addresses" # https://github.com/aio-libs/aiohttp/issues/3572, remove >= v4.0.0
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
