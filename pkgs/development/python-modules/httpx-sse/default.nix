{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  sse-starlette,
}:

buildPythonPackage rec {
  pname = "httpx-sse";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "florimondmanca";
    repo = "httpx-sse";
    tag = version;
    hash = "sha256-bSozSZmbRU5sc3jvVUOAXQWVBA8GhzM2R26uPdabS+w=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ httpx ];

  pythonImportsCheck = [ "httpx_sse" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    sse-starlette
  ];

  meta = with lib; {
    description = "Consume Server-Sent Event (SSE) messages with HTTPX";
    homepage = "https://github.com/florimondmanca/httpx-sse";
    changelog = "https://github.com/florimondmanca/httpx-sse/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
