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
}:

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "4.32.2";

  src = fetchFromGitHub {
    owner = "ets-labs";
    repo = "python-dependency-injector";
    rev = version;
    sha256 = "1gkkka0hl2hl4axf3gfm58mzv92bg0frr5jikw8g32hd4q4aagcg";
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

  disabledTestPaths = [
    # There is no unique identifier to disable the one failing test
    "tests/unit/ext/test_aiohttp_py35.py"
  ];

  pythonImportsCheck = [ "dependency_injector" ];

  meta = with lib; {
    description = "Dependency injection microframework for Python";
    homepage = "https://github.com/ets-labs/python-dependency-injector";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
