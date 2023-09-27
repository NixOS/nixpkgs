{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, regex
, pytestCheckHook
, js2py
, setuptools
}:

buildPythonPackage rec {
  pname = "lark";
  version = "1.1.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = "refs/tags/${version}";
    hash = "sha256-k74tozIgJuwtUqKKmYHlfLpCWyT2hdoygRJiIpw+GDE=";
  };

  patches = [
    # include .lark files in package data
    # https://github.com/lark-parser/lark/pull/1308
    (fetchpatch {
      url = "https://github.com/lark-parser/lark/commit/656334cb8793fd4e08a12843eaced5a7bb518be3.patch";
      hash = "sha256-pYeNnFfXJ8xkR0KsU/KMWJ8nF+BhP9PXEANiVhT254s=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  # Optional import, but fixes some re known bugs & allows advanced regex features
  propagatedBuildInputs = [ regex ];

  pythonImportsCheck = [
    "lark"
    "lark.parsers"
    "lark.tools"
    "lark.grammars"
  ];

  nativeCheckInputs = [
    js2py
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = "https://lark-parser.readthedocs.io/";
    changelog = "https://github.com/lark-parser/lark/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fridh drewrisinger ];
  };
}
