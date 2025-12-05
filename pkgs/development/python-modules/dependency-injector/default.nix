{
  lib,
  aiohttp,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  flask,
  httpx,
  mypy-boto3-s3,
  numpy,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "4.48.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ets-labs";
    repo = "python-dependency-injector";
    tag = version;
    hash = "sha256-jsV+PmUGtK8QiI2ga963H/gkd31UEq0SouEia+spSpg=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    pydantic = [ pydantic ];
    flask = [ flask ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    fastapi
    httpx
    mypy-boto3-s3
    numpy
    pytest-asyncio
    pytestCheckHook
    scipy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "dependency_injector" ];

  disabledTestPaths = [
    # Exclude tests for EOL Python releases
    "tests/unit/ext/test_aiohttp_py35.py"
    "tests/unit/wiring/test_*_py36.py"
    "tests/unit/providers/configuration/test_from_pydantic_py36.py"
    "tests/unit/providers/configuration/test_pydantic_settings_in_init_py36.py"
  ];

  meta = with lib; {
    description = "Dependency injection microframework for Python";
    homepage = "https://github.com/ets-labs/python-dependency-injector";
    changelog = "https://github.com/ets-labs/python-dependency-injector/blob/${src.tag}/docs/main/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
    # https://github.com/ets-labs/python-dependency-injector/issues/726
    broken = versionAtLeast pydantic.version "2";
  };
}
