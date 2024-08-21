{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools-scm,
  more-itertools,
  cssselect,
  jaraco-test,
  lxml,
  mock,
  pytestCheckHook,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.11.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "cssutils";
    rev = "refs/tags/v${version}";
    hash = "sha256-U9myMfKz1HpYVJXp85izRBpm2wjLHYZj8bUVt3ROTEg=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ more-itertools ];

  nativeCheckInputs = [
    cssselect
    jaraco-test
    lxml
    mock
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  disabledTests = [
    # access network
    "encutils"
    "website.logging"
  ];

  pythonImportsCheck = [ "cssutils" ];

  meta = with lib; {
    description = "CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/jaraco/cssutils";
    changelog = "https://github.com/jaraco/cssutils/blob/${src.rev}/NEWS.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
