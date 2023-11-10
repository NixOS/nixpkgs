{ lib
, stdenv
, brotli
, brotlicffi
, buildPythonPackage
, certifi
, chardet
, click
, fetchFromGitHub
, h2
, hatch-fancy-pypi-readme
, hatchling
, httpcore
, isPyPy
, multipart
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
  version = "0.25.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zQVavjU66ksO0FB1h32e0YUhOGiQ4jHPvjgLhtxjU6s=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

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

  # trustme uses pyopenssl
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  nativeCheckInputs = [
    chardet
    multipart
    pytestCheckHook
    pytest-asyncio
    pytest-trio
    trustme
    uvicorn
  ] ++ passthru.optional-dependencies.http2
    ++ passthru.optional-dependencies.brotli
    ++ passthru.optional-dependencies.socks;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "rfc3986[idna2008]>=1.3,<2" "rfc3986>=1.3"
  '';

  # testsuite wants to find installed packages for testing entrypoint
  preCheck = ''
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
    "-W" "ignore::trio.TrioDeprecationWarning"
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
    changelog = "https://github.com/encode/httpx/blob/${src.rev}/CHANGELOG.md";
    description = "The next generation HTTP client";
    homepage = "https://github.com/encode/httpx";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
