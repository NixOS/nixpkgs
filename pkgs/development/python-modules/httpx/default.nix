{ lib
, stdenv
, anyio
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
, idna
, isPyPy
, multipart
, pygments
, python
, pythonOlder
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
  version = "0.25.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rGtIrs4dffs7Ndtjb400q7JrZh+HG9k0uwHw9pRlC5s=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    anyio
    certifi
    httpcore
    idna
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
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
