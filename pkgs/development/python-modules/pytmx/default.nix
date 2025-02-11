{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pygame,
  pyglet,
  pysdl2,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytmx";
  version = "3.32";

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bitcraft";
    repo = "PyTMX";
    # Latest release was not tagged. However, the changes of this commit - the
    # current HEAD - are part of the 3.32 release on PyPI.
    rev = "7af805bc916e666fdf7165d5d6ba4c0eddfcde18";
    hash = "sha256-zRrMk812gAZoCAeYq4Uz/1RwJ0lJc7szyZ3IQDYZOd4=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    pygame
    pyglet
    pysdl2
  ];

  pythonImportsCheck = [
    "pytmx.pytmx"
    "pytmx.util_pygame"
    "pytmx.util_pyglet"
    "pytmx.util_pysdl2"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError on the property name
    "test_contains_reserved_property_name"
  ];

  meta = with lib; {
    homepage = "https://github.com/bitcraft/PyTMX";
    description = "Python library to read Tiled Map Editor's TMX maps";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ oxzi ];
  };
}
