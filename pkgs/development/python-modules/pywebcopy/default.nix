{
  lib,
  buildPythonPackage,
  cachecontrol,
  fetchFromGitHub,
  legacy-cgi,
  lxml-html-clean,
  pytestCheckHook,
  requests,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywebcopy";
  version = "7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rajatomar788";
    repo = "pywebcopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ee8uGg4PU1uch8cyiU7QfvdYFUVDz7obq9oC8fKkf1s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cachecontrol
    legacy-cgi
    lxml-html-clean
    requests
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pywebcopy" ];

  disabledTestPaths = [
    # Segfault
    "pywebcopy/tests/test_iterparser.py"
  ];

  meta = {
    description = "Python package for cloning complete webpages and websites to local storage";
    homepage = "https://github.com/rajatomar788/pywebcopy/";
    changelog = "https://github.com/rajatomar788/pywebcopy/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
