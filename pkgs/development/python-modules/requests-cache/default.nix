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
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "reclosedev";
    repo = "requests-cache";
    rev = "v${version}";
    sha256 = "sha256-HzOcPWmvUhqPtb/7Mnw6wWY7a4CwGRwPgq+7QoHJAc8=";
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

  # Integration tests require local DBs
  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "requests_cache" ];

  meta = with lib; {
    description = "Persistent cache for requests library";
    homepage = "https://github.com/reclosedev/requests-cache";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
