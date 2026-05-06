{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  pytestCheckHook,
  ament-copyright,
  ament-flake8,
  ament-mypy,
  ament-pep257,
  ament-xmllint,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-index-python";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_index";
    tag = finalAttrs.version;
    hash = "sha256-0gImRr+ZY2Wcx0uBRZVbodFbfDojhy75ZnTM2qEJ4yg=";
  };

  sourceRoot = "${finalAttrs.src.name}/ament_index_python";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    ament-copyright
    ament-flake8
    ament-mypy
    ament-pep257
    ament-xmllint
  ];

  env.XML_CATALOG_FILES = ament-xmllint.rosPackageCatalog;

  meta = {
    description = "Python API to access the ament resource index";
    homepage = "https://github.com/ament/ament_index";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "ament_index";
    platforms = lib.platforms.all;
  };
})
