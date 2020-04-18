{ buildPythonPackage
, fetchFromGitHub
, lib

# pythonPackages
, coverage
}:

buildPythonPackage rec {
  pname = "pyparsing";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "pyparsing";
    repo = pname;
    rev = "pyparsing_${version}";
    sha256 = "1fh7s3cfr274pd6hh6zygl99842rqws98an2nkrrqj2spb9ldxcm";
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
