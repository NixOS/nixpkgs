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
  version = "2.5";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03dzhjrsc5d2whyjngfrwvxn42058k0cjjr85x2wqzai8psr475k";
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
    maintainers = with maintainers; [ nand0p ];
  };
}
