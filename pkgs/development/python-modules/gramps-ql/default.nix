{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gramps,
  pyparsing,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gramps-ql";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "gramps-ql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EBmReELjLWjV+xqbMbPg9yiBf5TP4V2GmoXABzb4f3s=";
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

  pythonImportsCheck = [ "gramps_ql" ];

  meta = {
    description = "GQL - the Gramps Query Language";
    homepage = "https://github.com/DavidMStraub/gramps-ql";
    changelog = "https://github.com/DavidMStraub/gramps-ql/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
