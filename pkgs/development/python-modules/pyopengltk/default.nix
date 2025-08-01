{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyopengl,
  writers,
  tkinter,
  pyopengltk,
}:

buildPythonPackage rec {
  pname = "pyopengltk";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jonwright";
    repo = "pyopengltk";
    rev = "dbed7b7d01cc5a90fd3e79769259b1dc0894b673"; # there is no tag
    hash = "sha256-hQoTj8h/L5VZgmq7qgRImLBKZMecrilyir5Ar6ne4S0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyopengl
    tkinter
  ];

  doCheck = false;

  pythonImportsCheck = [ "pyopengltk" ];

  passthru.tests = {
    cube = writers.writePython3 "cube" {
      libraries = [ pyopengltk ];
      doCheck = false;
    } (builtins.readFile "${src}/examples/cube.py");
  };

  meta = {
    description = "OpenGL frame for Python/Tkinter via ctypes and pyopengl";
    homepage = "https://github.com/jonwright/pyopengltk";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.mit;
    # not supported yet, see: https://github.com/jonwright/pyopengltk/issues/12
    broken = stdenv.hostPlatform.isDarwin;
  };
}
