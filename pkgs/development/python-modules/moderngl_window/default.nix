{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, setuptools
, glfw
, moderngl
, numpy
, pillow
, pygame
, pyglet
, pyqt5
, pyrr
, pysdl2
, pyside2
, pythonOlder
, scipy
, trimesh
}:

buildPythonPackage rec {
  pname = "moderngl-window";
  version = "2.4.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = "moderngl_window";
    rev = "refs/tags/${version}";
    hash = "sha256-OfvIxezeZyuv5LLbe+4o1X2UCGnXT2DNvAF7t2Isw6Y=";
  };

  pythonRelaxDeps = [
    "pillow"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    moderngl
    pyglet
    pillow
    pyrr
  ];

  passthru.optional-dependencies = {
    trimesh = [
      trimesh
      scipy
    ];
    glfw = [
      glfw
    ];
    pygame = [
      pygame
    ];
    PySDL2 = [
      pysdl2
    ];
    PySide2 = [
      pyside2
    ];
    pyqt5 = [
      pyqt5
    ];
  };

  # Tests need a display to run.
  doCheck = false;

  pythonImportsCheck = [
    "moderngl_window"
  ];

  meta = with lib; {
    description = "Cross platform helper library for ModernGL making window creation and resource loading simple";
    homepage = "https://github.com/moderngl/moderngl-window";
    changelog = "https://github.com/moderngl/moderngl-window/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
    platforms = platforms.mesaPlatforms;
    broken = stdenv.isDarwin;
  };
}
