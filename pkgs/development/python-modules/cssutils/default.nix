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
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "cssutils";
    tag = "v${version}";
    hash = "sha256-kuqHfwJn+GT1VIC2PWu5Oj1X6SGn/bi2QPN8kfposVs=";
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
    changelog = "https://github.com/jaraco/cssutils/blob/${src.rev}/NEWS.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
