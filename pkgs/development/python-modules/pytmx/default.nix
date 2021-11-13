{ lib
, buildPythonPackage
, fetchFromGitHub
, pygame
, pyglet
, pysdl2
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytmx";
  version = "3.30";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bitcraft";
    repo = "PyTMX";
    rev = version;
    sha256 = "sha256-d6VPmRdqUO6YhkOYYeXOEcrli/35IFkxK73AcZYHixw=";
  };

  propagatedBuildInputs = [
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

  checkInputs = [
    pytestCheckHook
  ];

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
