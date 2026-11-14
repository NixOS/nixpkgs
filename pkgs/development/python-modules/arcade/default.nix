{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  attrs,
  typing-extensions,
  pyglet,
  pillow,
  pymunk,
}:
let
  pytiled-parser = buildPythonPackage {
    pname = "pytiled-parser";
    version = "v2.2.9";
    src = fetchFromGitHub {
      owner = "pythonarcade";
      repo = "pytiled_parser";
      rev = "v2.2.9";
      hash = "sha256-b7nioJ8BXGoJDfAS8edQtSBaF4ZBkmA+wIXsdvkcrPw=";
    };
    pyproject = true;
    build-system = [ setuptools ];
    dependencies = [
      attrs
      typing-extensions
    ];
  };
in
buildPythonPackage (finalAttrs: {
  pname = "arcade";
  version = "3.3.3";
  src = fetchFromGitHub {
    owner = "pythonarcade";
    repo = "arcade";
    tag = "3.3.3";
    hash = "sha256-z2fSgAKgjC/LkPfi/U9PkeeNGomVIsybM8bJnwAAASI=";
  };
  pyproject = true;
  build-system = [ setuptools ];
  dependencies = [
    pyglet
    pillow
    pymunk
    pytiled-parser
  ];
  pythonRelaxDeps = [
    "pillow"
    "pymunk"
  ];
  meta = {
    description = "Arcade is an easy-to-learn Python library for creating 2D video games. It is ideal for beginning programmers or programmers who want to create 2D games without learning a complex framework.";
    homepage = "https://api.arcade.academy/en/stable/";
    changelog = "https://github.com/pythonarcade/arcade/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.GirardR1006 ];
    platforms = lib.platforms.unix;
  };
})
