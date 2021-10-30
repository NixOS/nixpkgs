{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "opam-file-format";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "1fxhppdmrysr2nb5z3c448h17np48f3ga9jih33acj78r4rdblcs";
  };

  useDune2 = true;

  meta = with lib; {
    description = "Parser and printer for the opam file syntax";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl ];
    homepage = "https://github.com/ocaml/opam-file-format/";
  };
}
