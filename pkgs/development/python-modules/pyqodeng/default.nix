{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pygments,
  pyside6,
  qtpy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyqodeng";
  version = "0.0.14";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyqodeng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6EayPtWUd4Mruu6KbHVL3o3PUIZPfIxHqDr77o1+wjU=";
  };

  pythonRemoveDeps = [ "PySide6-Essentials" ];

  build-system = [ setuptools ];

  dependencies = [
    pygments
    pyside6
    qtpy
  ];

  pythonImportsCheck = [ "pyqodeng" ];

  meta = {
    description = "PyQt/PySide source code editor widget used by angr-management";
    homepage = "https://github.com/angr/pyqodeng";
    changelog = "https://github.com/angr/pyqodeng/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
})
