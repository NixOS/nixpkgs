{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  more-itertools,
  cssselect,
  jaraco-test,
  lxml,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "cssutils";
    tag = "v${version}";
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
  ];

  disabledTests = [
    # access network
    "encutils"
    "website.logging"
  ];

  pythonImportsCheck = [ "cssutils" ];

  meta = {
    description = "CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/jaraco/cssutils";
    changelog = "https://github.com/jaraco/cssutils/blob/${src.rev}/NEWS.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
