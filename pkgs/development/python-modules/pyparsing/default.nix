{ buildPythonPackage
, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "pyparsing";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "pyparsing";
    repo = pname;
    rev = "pyparsing_${version}";
    sha256 = "0n89ky7rx5yg09ssji8liahnyxip08hz7syc2k4pmlgs4978181a";
  };

  # only do unit tests, as diagram tests require railroad, which has
  # been unmaintained since 2015
  checkPhase = ''
    python -m unittest -k 'not testEmptyExpressionsAreHandledProperly' tests/test_unit.py
  '';

  meta = with lib; {
    homepage = "https://github.com/pyparsing/pyparsing";
    description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
