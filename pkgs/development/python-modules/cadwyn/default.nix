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

buildPythonPackage rec {
  pname = "cadwyn";
  version = "5.6.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zmievsa";
    repo = "cadwyn";
    tag = version;
    hash = "sha256-VVi79c/Y1mu520H/7gy9lGdBIVuKsYedU49P501NQao=";
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
    changelog = "https://github.com/zmievsa/cadwyn/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
}
