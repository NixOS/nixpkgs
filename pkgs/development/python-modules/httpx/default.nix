{ lib
, brotli
, brotlicffi
, buildPythonPackage
, certifi
, chardet
, click
, fetchFromGitHub
, h2
, httpcore
, isPyPy
, pygments
, python
, pythonOlder
, rfc3986
, rich
, sniffio
, socksio
, pytestCheckHook
, pytest-asyncio
, pytest-trio
, trustme
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.23.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    hash = "sha256-s11Yeizm3y3w5D6ACQ2wp/KJ0+1ALY/R71IlTP2pMC4=";
  };

  propagatedBuildInputs = [
    certifi
    httpcore
    rfc3986
    sniffio
  ];

  passthru.optional-dependencies = {
    http2 = [
      h2
    ];
    socks = [
      socksio
    ];
    brotli = if isPyPy then [
      brotlicffi
    ] else [
      brotli
    ];
    cli = [
      click
      rich
      pygments
    ];
  };

  checkInputs = [
    chardet
    pytestCheckHook
    pytest-asyncio
    pytest-trio
    trustme
    uvicorn
  ] ++ passthru.optional-dependencies.http2
    ++ passthru.optional-dependencies.brotli
    ++ passthru.optional-dependencies.socks;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "rfc3986[idna2008]>=1.3,<2" "rfc3986>=1.3"
  '';

  # testsuite wants to find installed packages for testing entrypoint
  preCheck = ''
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests = [
    # httpcore.ConnectError: [Errno 101] Network is unreachable
    "test_connect_timeout"
    # httpcore.ConnectError: [Errno -2] Name or service not known
    "test_async_proxy_close"
    "test_sync_proxy_close"
  ];

  disabledTestPaths = [
    "tests/test_main.py"
  ];

  pythonImportsCheck = [
    "httpx"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "The next generation HTTP client";
    homepage = "https://github.com/encode/httpx";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc fab ];
  };
}
