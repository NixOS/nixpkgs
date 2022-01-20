{ lib
, appdirs
, attrs
, buildPythonPackage
, bson
, cattrs
, fetchFromGitHub
, itsdangerous
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, requests-mock
, rich
, timeout-decorator
, ujson
, url-normalize
}:

buildPythonPackage rec {
  pname = "requests-cache";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "reclosedev";
    repo = "requests-cache";
    rev = "v${version}";
    sha256 = "0gz6fyc6lgbab9k92cihrp3711r1wcp4xhs25qp176zbzgccbj43";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    appdirs
    attrs
    bson
    cattrs
    itsdangerous
    pyyaml
    requests
    ujson
    url-normalize
  ];

  checkInputs = [
    pytestCheckHook
    requests-mock
    rich
    timeout-decorator
  ];

  pytestFlagsArray = [
    # Integration tests require local DBs
    "tests/unit"
  ];

  disabledTests = [
    # Tests are flaky in the sandbox
    "test_remove_expired_responses"
  ];

  pythonImportsCheck = [
    "requests_cache"
  ];

  meta = with lib; {
    description = "Persistent cache for requests library";
    homepage = "https://github.com/reclosedev/requests-cache";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
