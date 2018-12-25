{ stdenv, pytest, fetchFromGitHub, buildPythonPackage, appdirs }:

buildPythonPackage rec {
  pname = "rply";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "alex";
    repo = "rply";
    rev = "v${version}";
    sha256 = "0a9r81kaibgr26psss02rn2nc6bf84a8q9nsywkm1xcswy8xrmcx";
  };

  buildInputs = [ appdirs ];

  checkInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test tests
  '';

  meta = with stdenv.lib; {
    description = "A python Lex/Yacc that works with RPython";
    homepage = https://github.com/alex/rply;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
