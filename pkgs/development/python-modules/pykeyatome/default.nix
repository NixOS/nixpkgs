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
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jugla";
    repo = "pyKeyAtome";
    rev = "V${version}";
    sha256 = "1brcfgqj0bana6yii4083kppz822fgk9xf4mg141b0zfvx2gyjw9";
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
    homepage = "hhttps://github.com/jugla/pyKeyAtome";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
