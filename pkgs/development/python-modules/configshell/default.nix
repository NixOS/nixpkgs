{ stdenv, fetchFromGitHub, buildPythonPackage, pyparsing, six, urwid }:

buildPythonPackage rec {
  pname = "configshell";
  version = "1.1.27";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo ="${pname}-fb";
    rev = "v${version}";
    sha256 = "1nldzq3097xqgzd8qxv36ydvx6vj2crwanihz53k46is0myrwcnn";
  };

  propagatedBuildInputs = [ pyparsing six urwid ];

  meta = with stdenv.lib; {
    description = "A Python library for building configuration shells";
    homepage = https://github.com/open-iscsi/configshell-fb;
    license = licenses.asl20;
  };
}
