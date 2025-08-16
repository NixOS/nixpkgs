{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  gramps,
  pyparsing,

  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "gramps-ql";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "gramps-ql";
    tag = "v${version}";
    hash = "sha256-PdPkvZnEoe3xUt3xFmBu7cZEt609mNcADzpTHQ5jDtA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    gramps
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "gramps_ql"
  ];

  meta = {
    description = "Library to filter Gramps database objects by a query syntax";
    homepage = "https://github.com/DavidMStraub/gramps-ql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
