{ lib, fetchPypi, buildPythonPackage, pythonOlder, isPyPy
, lazy-object-proxy, six, wrapt, enum34, singledispatch, backports_functools_lru_cache
, pytest
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35b032003d6a863f5dcd7ec11abd5cd5893428beaa31ab164982403bcb311f22";
  };

  # From astroid/__pkginfo__.py
  propagatedBuildInputs = [
    lazy-object-proxy
    six
    wrapt
    enum34
    singledispatch
    backports_functools_lru_cache
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    # test_builtin_help is broken
    pytest -k "not test_builtin_help" astroid
  '';

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = https://github.com/PyCQA/astroid;
    license = licenses.lgpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nand0p ];
  };
}
