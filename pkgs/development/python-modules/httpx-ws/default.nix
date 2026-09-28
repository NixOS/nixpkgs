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
  starlette,
  trio,
  uvicorn,
  wsproto,
}:

buildPythonPackage rec {
  pname = "httpx-ws";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "httpx-ws";
    tag = "v${version}";
    hash = "sha256-e6D3sU6eWjsZnURIv1WfkSr54AMdDP9kHd263awzNsI=";
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

  meta = {
    description = "WebSocket support for HTTPX";
    homepage = "https://github.com/frankie567/httpx-ws";
    changelog = "https://github.com/frankie567/httpx-ws/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
