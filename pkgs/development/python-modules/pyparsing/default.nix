{ buildPythonPackage
, fetchFromGitHub
, lib

# pythonPackages
, coverage
}:

buildPythonPackage rec {
  pname = "pyparsing";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "pyparsing";
    repo = pname;
    rev = "pyparsing_${version}";
    sha256 = "14pfy80q2flgzjcx8jkracvnxxnr59kjzp3kdm5nh232gk1v6g6h";
  };

  # https://github.com/pyparsing/pyparsing/blob/847af590154743bae61a32c3dc1a6c2a19009f42/tox.ini#L6
  checkInputs = [ coverage ];
  checkPhase = ''
    coverage run --branch simple_unit_tests.py
    coverage run --branch unitTests.py
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
