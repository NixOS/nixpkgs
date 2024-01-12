{ lib
, anyio
, buildPythonPackage
, certifi
, fetchFromGitHub
, hatchling
, hatch-fancy-pypi-readme
, h11
, h2
, pproxy
, pytest-asyncio
, pytest-httpbin
, pytest-trio
, pytestCheckHook
, pythonOlder
, socksio
, trio
# for passthru.tests
, httpx
, httpx-socks
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "httpcore";
    rev = "refs/tags/${version}";
    hash = "sha256-gjAScRBzAuNiTSxspX6vzwTAdBIwVQbaSLEUFV1QP+E=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    certifi
    h11
  ];

  passthru.optional-dependencies = {
    asyncio = [
      anyio
    ];
    http2 = [
      h2
    ];
    socks = [
      socksio
    ];
    trio = [
      trio
    ];
  };

  nativeCheckInputs = [
    pproxy
    pytest-asyncio
    pytest-httpbin
    pytest-trio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "httpcore"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit httpx httpx-socks;
  };

  meta = with lib; {
    changelog = "https://github.com/encode/httpcore/blob/${version}/CHANGELOG.md";
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
