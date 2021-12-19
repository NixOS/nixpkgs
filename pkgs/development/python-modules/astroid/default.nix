{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPyPy
, lazy-object-proxy
, wrapt
, typed-ast
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.5.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rWO4VSxwk5VolmgRoIjvC8iA+ZokoAg0q9DjaBtRT5E=";
  };

  # From astroid/__pkginfo__.py
  propagatedBuildInputs = [
    lazy-object-proxy
    wrapt
  ] ++ lib.optional (!isPyPy && pythonOlder "3.8") typed-ast;

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
