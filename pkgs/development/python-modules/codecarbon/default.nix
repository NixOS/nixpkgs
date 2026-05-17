{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  arrow,
  authlib,
  click,
  nvidia-ml-py,
  pandas,
  prometheus-client,
  psutil,
  py-cpuinfo,
  pycountry,
  pydantic,
  questionary,
  rapidfuzz,
  requests,
  rich,
  typer,

  # optional-dependencies
  amdsmi,
  dash,
  dash-bootstrap-components,
  fire,

  # tests
  bcrypt,
  dependency-injector,
  email-validator,
  fastapi,
  fastapi-pagination,
  httpx,
  jwt,
  logfire,
  psycopg2,
  pydantic-settings,
  pytestCheckHook,
  requests-mock,
  responses,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "codecarbon";
  version = "3.2.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mlco2";
    repo = "codecarbon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nzt+CKXnv6zvWKsFD7duguVj0AA4eWZgFUlBdIEujD8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    arrow
    authlib
    click
    nvidia-ml-py
    pandas
    prometheus-client
    psutil
    py-cpuinfo
    pycountry
    pydantic
    questionary
    rapidfuzz
    requests
    rich
    typer
  ];

  optional-dependencies = {
    amdsmi = [
      amdsmi
    ];
    carbonboard = [
      dash
      dash-bootstrap-components
      fire
    ];
    viz-legacy = [
      dash
      dash-bootstrap-components
      fire
    ];
  };

  pythonImportsCheck = [ "codecarbon" ];

  nativeBuildInputs = [
    bcrypt
    dash
    dependency-injector
    email-validator
    fastapi
    fastapi-pagination
    httpx
    jwt
    logfire
    psycopg2
    pydantic-settings
    pytestCheckHook
    requests-mock
    responses
    sqlalchemy
  ];

  enabledTestPaths = [
    "carbonserver/tests/"
  ];

  disabledTestPaths = [
    # Fail in the sandbox:
    # FileNotFoundError: [Errno 2] No such file or directory: '/sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj'
    "examples/"

    # _pytest.outcomes.Exit: CODECARBON_API_URL is not defined
    "carbonserver/tests/api/integration/test_api_black_box.py"

    # Require unpackaged (and unmaintained) fief-client
    "carbonserver/tests/api/routers/"
    "carbonserver/tests/api/service/test_auth_provider.py"

    # Require internet access
    "carbonserver/tests/api/integration/test_project_cascade_delete.py"
  ];

  disabledTests = [
    # AttributeError: <module 'jwt' from ...> does not have the attribute 'decode'
    "test_check_user_from_jwt"
  ];

  meta = {
    description = "Track emissions from Compute and recommend ways to reduce their impact on the environment";
    homepage = "https://github.com/mlco2/codecarbon";
    changelog = "https://github.com/mlco2/codecarbon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
