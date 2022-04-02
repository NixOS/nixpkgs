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
  version = "0.9.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "reclosedev";
    repo = "requests-cache";
    rev = "v${version}";
    hash = "sha256-9eA2fx+j6WLbEkLaemwEuoWLUWlS0iF5AkR2YienN5g=";
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

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

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
