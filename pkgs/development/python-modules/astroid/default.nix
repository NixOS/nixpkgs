{ lib, fetchPypi, buildPythonPackage, pythonOlder, isPyPy
, lazy-object-proxy, six, wrapt, typing, typed-ast
, pytestrunner, pytest
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.2.5";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x5c8fiqa18frwwfdsw41lpqsyff3w4lxvjx9d5ccs4zfkhy2q35";
  };

  # From astroid/__pkginfo__.py
  propagatedBuildInputs = [ lazy-object-proxy six wrapt ]
    ++ lib.optional (pythonOlder "3.5") typing
    ++ lib.optional (!isPyPy) typed-ast;

  checkInputs = [ pytestrunner pytest ];

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = https://github.com/PyCQA/astroid;
    license = licenses.lgpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nand0p ];
  };
}
