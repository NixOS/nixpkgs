{ lib
, anyio
, buildPythonPackage
, certifi
, fetchFromGitHub
, fetchpatch
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
  version = "0.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    hash = "sha256-mnd2VRtuDU0hCpzrMOWXHEj3NkF0GL8jRLhbrT+jXzg=";
  };

  patches = [
    # upstream have moved to pytest-httpbin 2.x. we have not.
    (fetchpatch {
      name = "restore-httpbin-error-suppression.patch";
      url = "https://github.com/encode/httpcore/commit/168c8a71b299ba1e4b5a4a556dbcf3c30d953f53.patch";
      includes = [ "setup.cfg" ];
      revert = true;
      hash = "sha256-Re33tZAgKl+KSTFhbZoRz1jJVgb/6OxLjral8dBaOJE=";
    })
  ];

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
