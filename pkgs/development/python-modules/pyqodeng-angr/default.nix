{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  pygments,
  pyside6,
  pytestCheckHook,
  pytest-xdist,
  qtpy,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyqodeng-angr";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyqodeng";
    tag = "v${version}";
    hash = "sha256-QA/h5CHGrv3HYIrRaJ1Eq+iXXmQ6dYbq2zixeO9rS1c=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-quiet 'PySide6-Essentials' 'PySide6'
  '';

  build-system = [ setuptools ];

  dependencies = [
    pygments
    future
    qtpy
    pyside6
  ];

  # Tests appear to be broken with pyside6
  doCheck = false;

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    pyside6
  ];

  pythonImportsCheck = [ "pyqodeng" ];

  meta = {
    description = "Angr's fork of pyQode.core, used as part of angr management";
    homepage = "https://github.com/angr/pyqodeng";
    changelog = "https://github.com/angr/pyqodeng/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
