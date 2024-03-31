{ lib
, buildPythonPackage
, pythonAtLeast
, pythonOlder
, fetchFromGitHub
, setuptools-scm
, cssselect
, jaraco-test
, lxml
, mock
, pytestCheckHook
, importlib-resources
}:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.10.1";
  pyproject = true;

  disabled = pythonOlder "3.8";


  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "cssutils";
    rev = "refs/tags/v${version}";
    hash = "sha256-FK+EHdfsuCnWmnfUH18gyMq6CBXICBbhJj3XrscLLOA=";
  };

  build-system = [
    setuptools-scm
  ];

  nativeCheckInputs = [
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
    "encutils"
    "website.logging"
  ];

  pythonImportsCheck = [ "cssutils" ];

  meta = with lib; {
    description = "A CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/jaraco/cssutils";
    changelog = "https://github.com/jaraco/cssutils/blob/${src.rev}/NEWS.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
