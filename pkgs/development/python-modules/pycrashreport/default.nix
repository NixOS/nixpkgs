{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  typer,
}:

buildPythonPackage rec {
  pname = "pycrashreport";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "pycrashreport";
    tag = "v${version}";
    hash = "sha256-huiPTpcNwRY8IMHe4y4H/OBCdlDWhBiU9u1xTvLSDQk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    typer
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
