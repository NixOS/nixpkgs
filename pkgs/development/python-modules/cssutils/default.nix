{ lib
, buildPythonPackage
, pythonAtLeast
, pythonOlder
, fetchpatch
, fetchPypi
, setuptools
, setuptools-scm
, importlib-metadata
, cssselect
, jaraco-test
, lxml
, mock
, pytestCheckHook
, importlib-resources
}:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.6.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-99zSPBzskJ/fNjDeNG4UE7eyVVk23sFLouu5kTvwgY4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    cssselect
    jaraco-test
    lxml
    mock
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  disabledTests = [
    # access network
    "test_parseUrl"
    "encutils"
    "website.logging"
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
