{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # python dependencies
  annotated-types,
  anyio,
  fastapi,
  idna,
  pydantic,
  sniffio,
  starlette,
  typing-extensions,

  # tests
  pytestCheckHook,
  httpx,
}:

buildPythonPackage rec {
  pname = "scalar-fastapi";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scalar";
    repo = "scalar";
    pname = "scalar_fastapi";
    # The commit changed integrations/fastapi/package.json which defines version number
    rev = "0f4bd9da2706be09a8afba017465f55a62dc0975";
    hash = "sha256-FvbRsLEfdG2fqg14xXG0K1nn8+qX/Co9Sy2EOM0DTlg=";
  };
  sourceRoot = "${src.name}/integrations/fastapi";

  build-system = [
    setuptools
  ];

  dependencies = [
    annotated-types
    anyio
    fastapi
    idna
    pydantic
    sniffio
    starlette
    typing-extensions
  ];

  pythonImportsCheck = [
    "scalar_fastapi"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    httpx
  ];

  meta = {
    description = "Plugin for FastAPI to render a reference for your OpenAPI document";
    homepage = "https://github.com/scalar/scalar/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
