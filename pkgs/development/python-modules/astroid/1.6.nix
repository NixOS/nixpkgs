{ lib, fetchPypi, buildPythonPackage, pythonOlder, isPyPy
, lazy-object-proxy, six, wrapt, enum34, singledispatch, backports_functools_lru_cache
, pytest
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "1.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d25869fc7f44f1d9fb7d24fd7ea0639656f5355fc3089cd1f3d18c6ec6b124c7";
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
    pytest -k "not test_builtin_help and not test_namespace_and_file_mismatch and not test_namespace_package_pth_support and not test_nested_namespace_import" astroid
  '';

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = https://github.com/PyCQA/astroid;
    license = licenses.lgpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nand0p ];
  };
}
