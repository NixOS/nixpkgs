{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  encutils,
  more-itertools,
  cssselect,
  jaraco-test,
  lxml,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "cssutils";
    tag = "v${version}";
    hash = "sha256-K9jbuX7AueSB3AB7PAVjpQhzb3Umn9OoHaL4RrMzKEs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"coherent.licensed",' ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    encutils
    more-itertools
  ];

  nativeCheckInputs = [
    cssselect
    jaraco-test
    lxml
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # access network
    "website.logging"
  ];

  pythonImportsCheck = [ "cssutils" ];

  meta = {
    description = "CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/jaraco/cssutils";
    changelog = "https://github.com/jaraco/cssutils/blob/${src.tag}/NEWS.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
