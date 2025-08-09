{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  httpx,
  pytest-asyncio,
  pytestCheckHook,
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

  # pytest-cov configuration is not necessary for packaging
  postPatch = ''
    rm setup.cfg
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ httpx ];

  pythonImportsCheck = [ "httpx_sse" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    sse-starlette
  ];

  meta = with lib; {
    description = "Consume Server-Sent Event (SSE) messages with HTTPX";
    homepage = "https://github.com/florimondmanca/httpx-sse";
    changelog = "https://github.com/florimondmanca/httpx-sse/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
