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
, sniffio
, socksio
# for passthru.tests
, httpx
, httpx-socks
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.18.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-UEpERsB7jZlMqRtyHxLYBisfDbTGaAiTtsgU1WUpvtA=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-fancy-pypi-readme
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

  nativeCheckInputs = [
    pproxy
    pytest-asyncio
    pytest-httpbin
    pytest-trio
    pytestCheckHook
  ] ++ passthru.optional-dependencies.http2
    ++ passthru.optional-dependencies.socks;

  disabledTests = [
    # https://github.com/encode/httpcore/discussions/813
    "test_connection_pool_timeout_during_request"
    "test_connection_pool_timeout_during_response"
    "test_h11_timeout_during_request"
    "test_h11_timeout_during_response"
    "test_h2_timeout_during_handshake"
    "test_h2_timeout_during_request"
    "test_h2_timeout_during_response"
  ];

  pythonImportsCheck = [
    "httpcore"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit httpx httpx-socks;
  };

  meta = with lib; {
    changelog = "https://github.com/encode/httpcore/releases/tag/${version}";
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
