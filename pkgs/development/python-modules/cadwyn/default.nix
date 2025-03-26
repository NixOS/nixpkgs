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
}:

buildPythonPackage rec {
  pname = "cadwyn";
  version = "5.4.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zmievsa";
    repo = "cadwyn";
    tag = version;
    hash = "sha256-u5TNk0sATdTIEvM0Ri5U+o7/3gCG5Y+BTp3GGuBQAvE=";
  };

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
    pytestCheckHook
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
