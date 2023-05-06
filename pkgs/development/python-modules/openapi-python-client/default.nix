{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  autoflake,
  poetry-core,
  pyyaml,
  typer,
  colorama,
  httpx,
  python-dateutil,
  jinja2,
  black,
  pydantic,
  isort,
  shellingham,
  pytest-mock,
  pytestCheckHook,
  openapi-python-client-integration-tests,
}:

buildPythonPackage rec {
  pname = "openapi-python-client";
  version = "0.14.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "openapi-generators";
    repo = "openapi-python-client";
    rev = "v${version}";
    hash = "sha256-Etw0Iz5aAdu/K+WSmue9ux8qi0f/YKgZgVhqCbGVxE0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    autoflake
    black
    isort
    colorama
    httpx
    jinja2
    pydantic
    python-dateutil
    pyyaml
    shellingham
    typer
    openapi-python-client-integration-tests
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  # Disabling these tests since they require network
  disabledTests = [
    "test_end_to_end"
    "test_post_body_multipart"
    "test_post_parameters_header"
  ];

  meta = {
    changelog = "https://github.com/openapi-generators/openapi-python-client/blob/${src.rev}/CHANGELOG.md";
    description = "Generate modern Python clients from OpenAPI";
    homepage = "https://github.com/openapi-generators/openapi-python-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.drupol ];
  };
}
