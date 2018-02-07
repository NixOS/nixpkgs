{ stdenv, pytest, fetchFromGitHub, buildPythonPackage, appdirs }:

buildPythonPackage rec {
  pname = "rply";
  name = "${pname}-${version}";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "alex";
    repo = "rply";
    rev = "v${version}";
    sha256 = "0v05gdy5dval30wvz96lywvz2jyf000dp0pnrd1lwdx3cyywq659";
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
