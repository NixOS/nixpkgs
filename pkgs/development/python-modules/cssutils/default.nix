{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools-scm
, toml
, importlib-metadata
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.2.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bef59f6b59bdccbea8e36cb292d2be1b6be1b485fc4a9f5886616f19eb31aaf";
  };

  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # access network
    "test_parseUrl"
    "encutils"
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
