{
  lib,
  anyio,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  hatchling,
  hatch-fancy-pypi-readme,
  h11,
  h2,
  pproxy,
  pytest-asyncio,
  pytest-httpbin,
  pytest-trio,
  pytestCheckHook,
  pythonOlder,
  socksio,
  trio,
  # for passthru.tests
  httpx,
  httpx-socks,
  respx,
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "httpcore";
    rev = "refs/tags/${version}";
    hash = "sha256-sF/ymIoEnqWRX9b8knojIw+ySci/obXSttaNJLb+/nE=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    certifi
    h11
  ];

  optional-dependencies = {
    asyncio = [ anyio ];
    http2 = [ h2 ];
    socks = [ socksio ];
    trio = [ trio ];
  };

  nativeCheckInputs = [
    pproxy
    pytest-asyncio
    pytest-httpbin
    pytest-trio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "httpcore" ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit httpx httpx-socks respx;
  };

  meta = with lib; {
    changelog = "https://github.com/encode/httpcore/blob/${version}/CHANGELOG.md";
    description = "Minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
