{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  pygments,
  pyside6,
  qtpy,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyqodeng";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyqodeng";
    rev = "v${version}";
    hash = "sha256-QA/h5CHGrv3HYIrRaJ1Eq+iXXmQ6dYbq2zixeO9rS1c=";
  };

  patches = [ ./relax-deps.patch ];

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    pygments
    future
    qtpy
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
