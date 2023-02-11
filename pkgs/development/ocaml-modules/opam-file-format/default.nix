{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "opam-file-format";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "sha256-wnAnvLNOc9FRBdLIFR08OKVaIjSEqJrcCIn4hmtYtjY=";
  };

  useDune2 = true;

  meta = with lib; {
    description = "Parser and printer for the opam file syntax";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl ];
    homepage = "https://github.com/ocaml/opam-file-format/";
    changelog = "https://github.com/ocaml/opam-file-format/raw/${version}/CHANGES";
  };
}
