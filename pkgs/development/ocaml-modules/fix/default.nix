{ lib, fetchFromGitLab, buildDunePackage }:

buildDunePackage rec {
  pname = "fix";
  version = "20211231";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = "fix";
    rev = "${version}";
    sha256 = "sha256-T/tbiC95yzPb60AiEcvMRU47D8xUZNN5C4X33Y1VB9E=";
  };

  minimumOCamlVersion = "4.03";
  useDune2 = true;

  meta = with lib; {
    homepage = "https://gitlab.inria.fr/fpottier/fix/";
    description = "A simple OCaml module for computing the least solution of a system of monotone equations";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ vbgl ];
  };
}
