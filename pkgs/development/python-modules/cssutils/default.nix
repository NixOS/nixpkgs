{ lib
, buildPythonPackage
, pythonAtLeast
, pythonOlder
, fetchpatch
, fetchPypi
, setuptools-scm
, toml
, importlib-metadata
, cssselect
, lxml
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.3.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-stOxYEfKroLlxZADaTW6+htiHPRcLziIWvS+SDjw/QA=";
  };

  patches = lib.optionals (pythonAtLeast "3.10") [
    # fix tests for python3.10
    (fetchpatch {
      url = "https://github.com/jaraco/cssutils/pull/17/commits/355b1795dde77bd4b49d8df35377230fdb503802.patch";
      sha256 = "sha256-hwe8oeZO2rq00cs079lje3wjQDEczAu3Tfy/X/M9+GQ=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    cssselect
    lxml
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # access network
    "test_parseUrl"
    "encutils"
    "website.logging"
  ] ++ lib.optionals (pythonOlder "3.9") [
    # AttributeError: module 'importlib.resources' has no attribute 'files'
    "test_parseFile"
    "test_parseString"
    "test_combine"
  ];

  pythonImportsCheck = [ "cssutils" ];

  meta = with lib; {
    description = "A CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/jaraco/cssutils";
    changelog = "https://github.com/jaraco/cssutils/blob/v${version}/CHANGES.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
