{ lib, fetchFromGitHub, buildPythonPackage, pyparsing, six, urwid }:

buildPythonPackage rec {
  pname = "configshell";
  version = "1.1.29";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "0mjj3c9335sph8rhwww7j4zvhyk896fbmx887vibm89w3jpvjjr9";
  };

  propagatedBuildInputs = [ pyparsing six urwid ];

  meta = with lib; {
    description = "A Python library for building configuration shells";
    homepage = "https://github.com/open-iscsi/configshell-fb";
    license = licenses.asl20;
  };
}
