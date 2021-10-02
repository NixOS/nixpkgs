{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, isPyPy
, lazy-object-proxy
, wrapt
, typed-ast
, pytestCheckHook
, setuptools-scm
, pylint
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.7.3"; # Check whether the version is compatible with pylint

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "08qxw58cdyglkni6ahyil4cmnb48zz0wr4v05gzqk4r5ifs4gl2m";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION=version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  # From astroid/__pkginfo__.py
  propagatedBuildInputs = [
    lazy-object-proxy
    wrapt
  ] ++ lib.optional (!isPyPy && pythonOlder "3.8") typed-ast;

  checkInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
