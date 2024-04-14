{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-xprocess
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cachelib";
  version = "0.12.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-gSBY8zMGVn5Ndu4OexMP1v7bhXAAdl2UcEjjKFa21rE=";
  };

  nativeCheckInputs = [
    pytest-xprocess
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires set up local server
    "tests/test_dynamodb_cache.py"
    "tests/test_mongodb_cache.py"
  ];

  pythonImportsCheck = [ "cachelib" ];

  meta = with lib; {
    homepage = "https://github.com/pallets/cachelib";
    description = "Collection of cache libraries in the same API interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
  };
}
