{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  anyio,
  httpcore,
  httpx,
  wsproto,
  pytestCheckHook,
  starlette,
  trio,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "httpx-ws";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "httpx-ws";
    rev = "refs/tags/v${version}";
    hash = "sha256-eDc21FiGHi98doS4Zbubb/MVw4IjQ1q496TFHCX4xB4=";
  };

  # we don't need to use the hatch-regex-commit plugin
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'source = "regex_commit"' "" \
      --replace-fail 'commit_extra_args = ["-e"]' "" \
      --replace-fail '"hatch-regex-commit"' "" \
      --replace-fail 'addopts = "--cov=httpx_ws/ --cov-report=term-missing"' ""
  '';

  build-system = [ hatchling ];

  dependencies = [
    anyio
    httpcore
    httpx
    wsproto
  ];

  pythonImportsCheck = [ "httpx_ws" ];

  nativeCheckInputs = [
    pytestCheckHook
    starlette
    trio
    uvicorn
  ];

  disabledTestPaths = [
    # hang
    "tests/test_api.py"
  ];

  meta = with lib; {
    description = "WebSocket support for HTTPX";
    homepage = "https://github.com/frankie567/httpx-ws";
    license = licenses.mit;
  };
}
