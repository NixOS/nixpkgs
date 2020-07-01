{ stdenv, fetchFromGitHub, buildPythonPackage, pyparsing, six, urwid }:

buildPythonPackage rec {
  pname = "configshell";
  version = "1.1.28";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "1ym2hkvmmacgy21wnjwzyrcxyl3sx4bcx4hc51vf4lzcnj589l68";
  };

  propagatedBuildInputs = [ pyparsing six urwid ];

  meta = with stdenv.lib; {
    description = "A Python library for building configuration shells";
    homepage = "https://github.com/open-iscsi/configshell-fb";
    license = licenses.asl20;
  };
}
