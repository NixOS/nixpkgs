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
  six,
}:

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "4.41.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ets-labs";
    repo = "python-dependency-injector";
    rev = version;
    hash = "sha256-U3U/L8UuYrfpm4KwVNmViTbam7QdZd2vp1p+ENtOJlw=";
  };

  propagatedBuildInputs = [ six ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    pydantic = [ pydantic ];
    flask = [ flask ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs =
    [
      fastapi
      httpx
      mypy-boto3-s3
      numpy
      pytest-asyncio
      pytestCheckHook
      scipy
    ]
    ++ optional-dependencies.aiohttp
    ++ optional-dependencies.pydantic
    ++ optional-dependencies.yaml
    ++ optional-dependencies.flask;

  pythonImportsCheck = [ "dependency_injector" ];

  disabledTestPaths = [
    # Exclude tests for EOL Python releases
    "tests/unit/ext/test_aiohttp_py35.py"
    "tests/unit/wiring/test_*_py36.py"
  ];

  meta = with lib; {
    description = "Dependency injection microframework for Python";
    homepage = "https://github.com/ets-labs/python-dependency-injector";
    changelog = "https://github.com/ets-labs/python-dependency-injector/blob/${version}/docs/main/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
    # https://github.com/ets-labs/python-dependency-injector/issues/726
    broken = versionAtLeast pydantic.version "2";
  };
}
