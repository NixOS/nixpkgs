{
  lib,
  buildPythonPackage,
  fake-useragent,
  fetchFromGitHub,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  responses,
  simplejson,
}:

buildPythonPackage rec {
  pname = "pykeyatome";
  version = "2.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jugla";
    repo = "pyKeyAtome";
    tag = "V${version}";
    hash = "sha256-zRXUjekawf2/zTSlXqHVB02dDkb6HbU4NN6UBgl2rtg=";
  };

  propagatedBuildInputs = [
    fake-useragent
    requests
    simplejson
  ];

  nativeCheckInputs = [
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

  pythonImportsCheck = [ "pykeyatome" ];

  meta = with lib; {
    description = "Python module to get data from Atome Key";
    mainProgram = "pykeyatome";
    homepage = "https://github.com/jugla/pyKeyAtome";
    changelog = "https://github.com/jugla/pyKeyAtome/releases/tag/V${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
