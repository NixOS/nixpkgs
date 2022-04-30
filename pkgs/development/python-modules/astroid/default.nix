{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, isPyPy
, lazy-object-proxy
, wrapt
, typing-extensions
, typed-ast
, pytestCheckHook
, setuptools-scm
, pylint
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.11.2"; # Check whether the version is compatible with pylint

  disabled = pythonOlder "3.6.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-adnvJCchsMWQxsIlenndUb6Mw1MgCNAanZcTmssmsEc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    lazy-object-proxy
    wrapt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optional (!isPyPy && pythonOlder "3.8") typed-ast;

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # assert (1, 1) == (1, 16)
    "test_end_lineno_string"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    # AssertionError: Lists differ: ['ABC[16 chars]yBase', 'Final', 'Generic', 'MyProtocol', 'Protocol', 'object'] != ['ABC[16 chars]yBase', 'Final', 'Generic', 'MyProtocol', 'object']
    "test_mro_typing_extensions"
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
