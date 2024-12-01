{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  moderngl,
  numpy,
  pillow,
  pyglet,
  pyglm,

  # optional-dependencies
  trimesh,
  scipy,
  glfw,
  pygame,
  pysdl2,
  pyside2,
  pyqt5,

  mesa,
}:

buildPythonPackage rec {
  pname = "moderngl-window";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = "moderngl_window";
    rev = "refs/tags/${version}";
    hash = "sha256-J7vcEuJC0fVYyalSm9jDT44mLThoMw78Xmj5Ap3Q9ME=";
  };

  pythonRelaxDeps = [ "pillow" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    moderngl
    numpy
    pillow
    pyglet
    pyglm
  ];

  optional-dependencies = {
    trimesh = [
      trimesh
      scipy
    ];
    glfw = [ glfw ];
    pygame = [ pygame ];
    PySDL2 = [ pysdl2 ];
    PySide2 = [ pyside2 ];
    pyqt5 = [ pyqt5 ];
  };

  # Tests need a display to run.
  doCheck = false;

  pythonImportsCheck = [ "moderngl_window" ];

  meta = {
    description = "Cross platform helper library for ModernGL making window creation and resource loading simple";
    homepage = "https://github.com/moderngl/moderngl-window";
    changelog = "https://github.com/moderngl/moderngl-window/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c0deaddict ];
    inherit (mesa.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
