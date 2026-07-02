{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fonttools,
  pyclipper,
  defcon,
  fontpens,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "booleanoperations";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "typemytype";
    repo = "booleanOperations";
    tag = finalAttrs.version;
    hash = "sha256-IJyb6g2xwWj82Vm33Mtkqen1X/w0tSaP+Q/DtFc8Dd4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    pyclipper
  ];

  pythonImportsCheck = [ "booleanOperations" ];

  nativeCheckInputs = [
    defcon
    fontpens
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/typemytype/booleanOperations/releases/tag/${finalAttrs.src.tag}";
    description = "Boolean operations on paths";
    homepage = "https://github.com/typemytype/booleanOperations";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
