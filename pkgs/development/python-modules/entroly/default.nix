{
  lib,
  buildPythonPackage,
  entroly-core,
  fetchFromGitHub,
  hatchling,
  httpx,
  mcp,
  pyaml,
  starlette,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "entroly";
  version = "1.0.87";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "juyterman1000";
    repo = "entroly";
    rev = "entroly-v${finalAttrs.version}";
    hash = "sha256-xWCfEV91zUOQdHTh+v4e+/JkTD8nkyln0Mv/7NUoWko=";
  };

  build-system = [ hatchling ];

  dependencies = [
    entroly-core
    httpx
    mcp
    pyaml
    starlette
    uvicorn
  ];

  # Disable checking if dogfooding and strict audit tests require a live non-sandboxed environment
  dontCheck = true;

  pythonImportsCheck = [ "entroly" ];

  meta = {
    description = "Information-theoretic context optimization for AI coding agents";
    homepage = "https://github.com/juyterman1000/entroly";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.guelakais ];
    mainProgram = "entroly";
  };
})
