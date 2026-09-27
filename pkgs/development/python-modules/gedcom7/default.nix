{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gedcom7";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "python-gedcom7";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4gsQ7Cnk83NVGuwvnMFsKUN58DsnRuNY1P1xVMkxLoU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gedcom7" ];

  meta = {
    description = "GEDCOM 7 parser and serializer for Python";
    homepage = "https://github.com/DavidMStraub/python-gedcom7";
    changelog = "https://github.com/DavidMStraub/python-gedcom7/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
