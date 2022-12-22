{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, isPyPy
, lazy-object-proxy
, setuptools
, typing-extensions
, typed-ast
, pylint
, pytestCheckHook
, wrapt
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.12.12"; # Check whether the version is compatible with pylint
  format = "pyproject";

  disabled = pythonOlder "3.7.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FN/bBAxx9p1iAB3WXIZyyKv/zse7xtXzslclADMbouA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    lazy-object-proxy
    wrapt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optionals (!isPyPy && pythonOlder "3.8") [
    typed-ast
  ];

  checkInputs = [
    pytestCheckHook
    typing-extensions
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
