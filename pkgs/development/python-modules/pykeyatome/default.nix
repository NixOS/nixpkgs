{ lib
, buildPythonPackage
, fake-useragent
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, responses
, simplejson
}:

buildPythonPackage rec {
  pname = "pykeyatome";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jugla";
    repo = "pyKeyAtome";
    rev = "refs/tags/V${version}";
    sha256 = "sha256-rmiZ687h8imJXxyepDZor9JyjT2jbg1Lsd5oUtsQtro=";
  };

  propagatedBuildInputs = [
    fake-useragent
    requests
    simplejson
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
    requests-mock
    responses
  ];

  disabledTests = [
    # Tests require network access
    "test_consumption"
    "test_get_live"
    "test_login"
    "test_relog_after_session_down"
  ];

  pythonImportsCheck = [
    "pykeyatome"
  ];

  meta = with lib; {
    description = "Python module to get data from Atome Key";
    homepage = "https://github.com/jugla/pyKeyAtome";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
