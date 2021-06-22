{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, attrs
, itsdangerous
, requests
, url-normalize
, pytestCheckHook
, requests-mock
, timeout-decorator
}:

buildPythonPackage rec {
  pname = "requests-cache";
  version = "0.6.4";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "reclosedev";
    repo = "requests-cache";
    rev = "v${version}";
    sha256 = "10rvs611j16kakqx38kpqpc1v0dfb9rmbz2whpskswb1lsksv3j9";
  };

  propagatedBuildInputs = [
    attrs
    itsdangerous
    requests
    url-normalize
  ];

  checkInputs = [
    pytestCheckHook
    requests-mock
    timeout-decorator
  ];

  disabledTestPaths = [
    # connect to database on localhost
    "tests/integration/test_cache.py"
    "tests/integration/test_dynamodb.py"
    "tests/integration/test_gridfs.py"
    "tests/integration/test_mongodb.py"
    "tests/integration/test_redis.py"
  ];

  pythonImportsCheck = [ "requests_cache" ];

  meta = with lib; {
    description = "Persistent cache for requests library";
    homepage = "https://github.com/reclosedev/requests-cache";
    license = licenses.bsd3;
  };
}
