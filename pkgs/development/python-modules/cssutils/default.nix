{ lib
, buildPythonPackage
, pythonOlder
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
