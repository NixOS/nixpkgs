{ stdenv, fetchFromGitHub, buildPythonPackage, pyparsing, six, urwid }:

buildPythonPackage rec {
  pname = "configshell";
  version = "1.1.26";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo ="${pname}-fb";
    rev = "v${version}";
    sha256 = "0y2mk4y3462k2vmrydfrf5zvq55nbqxrjh0dhz8nsz5km4fzaxng";
  };

  propagatedBuildInputs = [ pyparsing six urwid ];

  meta = with stdenv.lib; {
    description = "A Python library for building configuration shells";
    homepage = https://github.com/open-iscsi/configshell-fb;
    license = licenses.asl20;
  };
}
