{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-xprocess
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cachelib";
  version = "0.10.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2V2FvZC8jM84fZEdK9ShzFrjO8goOQsN6cnJTHDDL9E=";
  };

  nativeCheckInputs = [
    pytest-xprocess
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires set up local server
    "tests/test_dynamodb_cache.py"
  ];

  pythonImportsCheck = [ "cachelib" ];

  meta = with lib; {
    homepage = "https://github.com/pallets/cachelib";
    description = "Collection of cache libraries in the same API interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
  };
}
