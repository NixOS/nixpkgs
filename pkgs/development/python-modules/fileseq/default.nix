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
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justinfx";
    repo = "fileseq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yPPqEhyg1+fqJHnS0zQF8/XJiA5Kn18/Ntc5LEoRJOM=";
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
