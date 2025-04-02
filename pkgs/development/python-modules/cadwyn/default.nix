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
  # test dependencies
  dirty-equals,
  httpx,
  inline-snapshot,
  pytest,
  pytest-fixture-classes,
  python-multipart,
  svcs,
  typer,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "cadwyn";
  version = "5.1.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zmievsa";
    repo = "cadwyn";
    tag = version;
    hash = "sha256-7sVic20mBx9bYRHKlYlyQ7pQNsrsOzzFcVIRKhgm8/E=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pytestCheckHook ];

  dependencies = [
    fastapi
    issubclass
    jinja2
    pydantic
    starlette
    typing-extensions
  ];

  pythonImportsCheck = [ "cadwyn" ];

  nativeCheckInputs = [
    dirty-equals
    httpx
    inline-snapshot
    pytest
    pytest-fixture-classes
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
