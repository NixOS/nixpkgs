{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "fileseq";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justinfx";
    repo = "fileseq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BO/2VwItRuef0wJNqU+q91JxgNMbZiiCW89XYoKmuHo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fileseq" ];

  meta = {
    description = "Python library for parsing frame ranges";
    homepage = "https://github.com/justinfx/fileseq";
    changelog = "https://github.com/justinfx/fileseq/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ aaronwuerth ];
    license = lib.licenses.mit;
  };
})
