{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  # runtime dependencies
  fastapi,
  issubclass,
  jinja2,
  pydantic,
  starlette,
  typing-extensions,
  typing-inspection,
  # test dependencies
  dirty-equals,
  httpx,
  inline-snapshot,
  pydantic-settings,
  pytest-fixture-classes,
  python-multipart,
  svcs,
  typer,
  uvicorn,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "cadwyn";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zmievsa";
    repo = "cadwyn";
    tag = finalAttrs.version;
    hash = "sha256-wvwR4JCPvWoWSdkK61oDmQWNq2UnDZMRlWxo1GLznjk=";
  };

  disabled = pythonAtLeast "3.14";

  build-system = [ hatchling ];

  dependencies = [
    fastapi
    issubclass
    jinja2
    pydantic
    starlette
    typing-extensions
    typing-inspection
  ];

  pythonImportsCheck = [ "cadwyn" ];

  nativeCheckInputs = [
    dirty-equals
    httpx
    inline-snapshot
    pydantic-settings
    pytest-fixture-classes
    pytestCheckHook
    python-multipart
    svcs
    typer
    uvicorn
  ];

  meta = {
    description = "Production-ready community-driven modern Stripe-like API versioning in FastAPI";
    homepage = "https://github.com/zmievsa/cadwyn";
    changelog = "https://github.com/zmievsa/cadwyn/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
})
