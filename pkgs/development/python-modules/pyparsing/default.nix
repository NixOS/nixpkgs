{ buildPythonPackage
, fetchFromGitHub
, lib
, flit-core
, jinja2
, pytestCheckHook
, railroad-diagrams
, pyparsing
}:

buildPythonPackage rec {
  pname = "pyparsing";
  version = "3.0.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyparsing";
    repo = pname;
    rev = "pyparsing_${version}";
    sha256 = "sha256-aCRyJQyLf8qQ6NO41q+HC856TjIHzIt0vyVBLV+3teE=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # circular dependencies with pytest if enabled by default
  doCheck = false;
  nativeCheckInputs = [
    jinja2
    pytestCheckHook
    railroad-diagrams
  ];

  pythonImportsCheck = [ "pyparsing" ];

  passthru.tests = {
    check = pyparsing.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    homepage = "https://github.com/pyparsing/pyparsing";
    description = "Python library for creating PEG parsers";
    longDescription = ''
      The pyparsing module is an alternative approach to creating and executing
      simple grammars, vs. the traditional lex/yacc approach, or the use of
      regular expressions. The pyparsing module provides a library of classes
      that client code uses to construct the grammar directly in Python code.
   '';
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
