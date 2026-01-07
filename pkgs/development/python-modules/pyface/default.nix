{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  numpy,
  pillow,
  pygments,
  pyqt5,
  pyqt6,
  pyside2,
  pyside6,
  setuptools,
  traits,
  traitsui,
  wxpython,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyface";
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "pyface";
    tag = finalAttrs.version;
    hash = "sha256-i97cosaFc5GTv5GJgpx1xc81mir/IWljSrAORUapymM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    traits
  ];

  optional-dependencies = {
    pillow = [ pillow ];
    pyqt5 = [
      pygments
      pyqt5
    ];
    pyqt6 = [
      pygments
      pyqt6
    ];
    pyside2 = [
      pygments
      pyside2
    ];
    pyside6 = [
      pygments
      pyside6
    ];
    numpy = [ numpy ];
    traitsui = [ traitsui ];
    wx = [
      wxpython
      numpy
    ];
  };

  doCheck = false; # Needs X server

  pythonImportsCheck = [ "pyface" ];

  meta = {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/pyface";
    changelog = "https://github.com/enthought/pyface/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ ];
    license = lib.licenses.bsdOriginal;
  };
})
