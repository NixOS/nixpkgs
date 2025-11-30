{
  buildPythonPackage,
  cached-property,
  click,
  fetchFromGitHub,
  la-panic,
  lib,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pycrashreport";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "pycrashreport";
    tag = "v${version}";
    hash = "sha256-QhHjQO/swoFYKlHaqpaU1qIGwHIK5Eq3ZHrFJEHZbWs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cached-property
    click
    la-panic
  ];

  pythonImportsCheck = [ "pycrashreport" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/doronz88/pycrashreport/releases/tag/${src.tag}";
    description = "Python3 parser for Apple's crash reports";
    homepage = "https://github.com/doronz88/pycrashreport";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pycrashreport";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
