{ lib, fetchPypi, buildPythonPackage, pythonOlder, isPyPy
, lazy-object-proxy, six, wrapt, enum34, singledispatch, backports_functools_lru_cache
, pytest
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "1.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fir4b67sm7shcacah9n61pvq313m523jb4q80sycrh3p8nmi6zw";
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
