{ lib
, anyio
, buildPythonPackage
, certifi
, fetchFromGitHub
, h11
, h2
, pproxy
, pytest-asyncio
, pytest-httpbin
, pytest-trio
, pytestCheckHook
, pythonOlder
, sniffio
, socksio
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.16.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    hash = "sha256-bwGZ/B0jlvc1BmXVTo7gMP6PJIQuCHclkHjKQCgMsyU=";
  };

  propagatedBuildInputs = [
    anyio
    certifi
    h11
    sniffio
  ];

  passthru.optional-dependencies = {
    http2 = [
      h2
    ];
    socks = [
      socksio
    ];
  };

  checkInputs = [
    pproxy
    pytest-asyncio
    pytest-httpbin
    pytest-trio
    pytestCheckHook
  ] ++ passthru.optional-dependencies.http2
    ++ passthru.optional-dependencies.socks;

  pythonImportsCheck = [
    "httpcore"
  ];

  preCheck = ''
    # remove upstreams pytest flags which cause:
    # httpcore.ConnectError: TLS/SSL connection has been closed (EOF) (_ssl.c:997)
    rm setup.cfg
  '';

  pytestFlagsArray = [
    "--asyncio-mode=strict"
  ];

  meta = with lib; {
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
