{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  # runtime dependencies
  fastapi,
  jinja2,
  pydantic,
  starlette,
  typing-extensions,
  typing-inspection,
  # test dependencies
  dirty-equals,
  fastapi-pagination,
  httpx,
  inline-snapshot,
  pydantic-settings,
  pytest-fixture-classes,
  python-multipart,
  sqlalchemy,
  sqlmodel,
  svcs,
  typer,
  uvicorn,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "cadwyn";
  version = "8.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zmievsa";
    repo = "cadwyn";
    tag = finalAttrs.version;
    hash = "sha256-DPUDgrM4OPv3XU/EJynxP7P1M3M7R+2loVBUlEzQI+A=";
  };

  build-system = [ hatchling ];

  dependencies = [
    fastapi
    jinja2
    pydantic
    starlette
    typing-extensions
    typing-inspection
  ];

  pythonImportsCheck = [ "cadwyn" ];

  nativeCheckInputs = [
    dirty-equals
    fastapi-pagination
    httpx
    inline-snapshot
    pydantic-settings
    pytest-fixture-classes
    pytestCheckHook
    python-multipart
    sqlalchemy
    sqlmodel
    svcs
    typer
    uvicorn
  ];

  disabledTests = [
    # Tries to find cadwyn executable in sys.executable.parent which does not exist during checkPhase
    "test__cadwyn_console_script__run_from_directory_with_user_modules__should_import_them_from_that_directory"
    "test__render_module__from_app_directory__should_print_module_schemas_in_that_version"
    "test__render_model__from_app_directory__should_print_schema_in_that_version"
  ];

  meta = {
    description = "Production-ready community-driven modern Stripe-like API versioning in FastAPI";
    homepage = "https://github.com/zmievsa/cadwyn";
    changelog = "https://github.com/zmievsa/cadwyn/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
})
