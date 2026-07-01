{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # build inputs
  starlette,
  brotli,
  # check inputs
  httpx,
  requests,
  mypy,
  brotlipy,
}:
buildPythonPackage (finalAttrs: {
  pname = "brotli-asgi";
  version = "1.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fullonic";
    repo = "brotli-asgi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cF7A3mnkQmvtc9DgHiwqYEQQ6QagjoBGTmcBzUm6vvs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    starlette
    brotli
  ];

  pythonImportsCheck = [ "brotli_asgi" ];

  nativeCheckInputs = [
    httpx
    requests
    mypy
    brotlipy
  ];

  meta = {
    description = "Compression AGSI middleware using brotli";
    homepage = "https://github.com/fullonic/brotli-asgi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
