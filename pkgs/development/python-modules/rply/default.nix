{ lib, pytest, fetchFromGitHub, buildPythonPackage, appdirs }:

buildPythonPackage rec {
  pname = "rply";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "alex";
    repo = "rply";
    rev = "v${version}";
    sha256 = "1qv37hn7hhxd388znri76g0zjxsbwhxhcaic94dvw9pq4l60vqp6";
  };

  propagatedBuildInputs = [ appdirs ];

  checkInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test tests
  '';

  meta = with lib; {
    description = "A python Lex/Yacc that works with RPython";
    homepage = "https://github.com/alex/rply";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
