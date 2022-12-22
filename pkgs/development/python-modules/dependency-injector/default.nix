{ lib
, aiohttp
, buildPythonPackage
, fastapi
, fetchFromGitHub
, flask
, httpx
, mypy-boto3-s3
, numpy
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pyyaml
, scipy
, six
}:

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "4.40.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ets-labs";
    repo = "python-dependency-injector";
    rev = version;
    hash = "sha256-lcgPFdAgLmv7ILL2VVfqtGSw96aUfPv9oiOhksRtF3k=";
  };

  propagatedBuildInputs = [
    six
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    pydantic = [
      pydantic
    ];
    flask = [
      flask
    ];
    yaml = [
      pyyaml
    ];
  };

  checkInputs = [
    fastapi
    httpx
    mypy-boto3-s3
    numpy
    pytest-asyncio
    pytestCheckHook
    scipy
  ] ++ passthru.optional-dependencies.aiohttp
  ++ passthru.optional-dependencies.pydantic
  ++ passthru.optional-dependencies.yaml
  ++ passthru.optional-dependencies.flask;

  pythonImportsCheck = [
    "dependency_injector"
  ];

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
  };
}
