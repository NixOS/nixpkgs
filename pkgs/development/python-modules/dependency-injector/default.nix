{ lib
, aiohttp
, buildPythonPackage
, fastapi
, fetchFromGitHub
, flask
, httpx
, mypy-boto3-s3
, numpy
, scipy
, pydantic
, pytestCheckHook
, pyyaml
, six
, pythonOlder
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

  checkInputs = [
    aiohttp
    fastapi
    flask
    httpx
    mypy-boto3-s3
    numpy
    pydantic
    scipy
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [
    "dependency_injector"
  ];

  meta = with lib; {
    description = "Dependency injection microframework for Python";
    homepage = "https://github.com/ets-labs/python-dependency-injector";
    changelog = "https://github.com/ets-labs/python-dependency-injector/blob/${version}/docs/main/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
