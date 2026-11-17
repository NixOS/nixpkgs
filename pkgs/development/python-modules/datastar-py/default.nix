{
  anyio,
  buildPythonPackage,
  django,
  fastapi,
  fetchFromGitHub,
  hatchling,
  httpx,
  lib,
  litestar,
  pytestCheckHook,
  starlette,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "datastar-py";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "starfederation";
    repo = "datastar-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-af6B1/1eBC0L20YJ6PkKBCg8dM+60+gRmvL+FH52u1U=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "datastar_py" ];

  nativeCheckInputs = [
    anyio
    django
    fastapi
    httpx
    litestar
    pytestCheckHook
    starlette
    uvicorn
  ];

  meta = {
    changelog = "https://github.com/starfederation/datastar-python/releases/tag/${finalAttrs.src.tag}";
    description = "Helper functions and classes for the Datastar library";
    homepage = "https://github.com/starfederation/datastar-python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
