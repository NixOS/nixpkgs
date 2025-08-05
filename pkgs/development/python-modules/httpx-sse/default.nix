{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  setuptools-scm,
  wheel,
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

  patches = [
    (fetchpatch2 {
      url = "https://github.com/florimondmanca/httpx-sse/commit/643938c805e671fa20adcf314b447f862b77bcda.patch?full_index=1";
      hash = "sha256-V2PyTlleyoLa0DuvdlU8zGNsI9C8bTjMUcLjx81/e5k=";
    })
  ];

  # pytest-cov configuration is not necessary for packaging
  postPatch = ''
    rm setup.cfg
  '';

  build-system = [
    setuptools
    setuptools-scm
    wheel
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
