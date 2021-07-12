{ lib, fetchFromGitLab, buildDunePackage }:

buildDunePackage rec {
  pname = "fix";
  version = "20201120";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = "fix";
    rev = "${version}";
    sha256 = "sha256-RO+JCG6R2i5uZfwTYEnQBCVq963fjv5lA2wA/8KrgMg=";
  };

  minimumOCamlVersion = "4.03";
  useDune2 = true;

  meta = with lib; {
    homepage = "https://gitlab.inria.fr/fpottier/fix/";
    description = "A simple OCaml module for computing the least solution of a system of monotone equations";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
  };
}
