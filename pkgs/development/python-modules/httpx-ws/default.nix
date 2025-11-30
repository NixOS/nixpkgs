{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpcore,
  httpx,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  starlette,
  trio,
  uvicorn,
  wsproto,
}:

buildPythonPackage rec {
  pname = "httpx-ws";
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "httpx-ws";
    tag = "v${version}";
    hash = "sha256-ixaD7X6V/tUalZbYtic7D9lRqv8yGnwl+j5m832n/hQ=";
  };

  # we don't need to use the hatch-regex-commit plugin
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'source = "regex_commit"' "" \
      --replace-fail 'commit_extra_args = ["-e"]' "" \
      --replace-fail '"hatch-regex-commit"' ""
  '';

  build-system = [ hatchling ];

  dependencies = [
    anyio
    httpcore
    httpx
    wsproto
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    starlette
    trio
    uvicorn
  ];

  pythonImportsCheck = [ "httpx_ws" ];

  disabledTestPaths = [
    # hang
    "tests/test_api.py"
  ];

  meta = with lib; {
    description = "WebSocket support for HTTPX";
    homepage = "https://github.com/frankie567/httpx-ws";
    changelog = "https://github.com/frankie567/httpx-ws/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
