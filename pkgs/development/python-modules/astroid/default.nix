{ lib, fetchPypi, buildPythonPackage, pythonOlder, isPyPy
, lazy-object-proxy, six, wrapt, typing, typed-ast
, pytestrunner, pytest
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.4.1";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c17cea3e592c21b6e222f673868961bad77e1f985cb1694ed077475a89229c1";
  };

  postPatch = ''
    substituteInPlace astroid/__pkginfo__.py --replace "lazy_object_proxy==1.4.*" "lazy_object_proxy"
  '';

  # From astroid/__pkginfo__.py
  propagatedBuildInputs = [ lazy-object-proxy six wrapt ]
    ++ lib.optional (pythonOlder "3.5") typing
    ++ lib.optional (!isPyPy) typed-ast;

  checkInputs = [ pytestrunner pytest ];

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nand0p ];
  };
}
