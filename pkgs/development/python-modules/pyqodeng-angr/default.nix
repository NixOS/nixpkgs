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
}:

buildPythonPackage rec {
  pname = "pyqodeng-angr";
  version = "0.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyqodeng";
    tag = "v${version}";
    hash = "sha256-t4LcPVQfktAaTqTr9L2VDCEHbSO7qxCvUDz6rj0Zre4=";
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
    changelog = "https://github.com/angr/pyqodeng/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
