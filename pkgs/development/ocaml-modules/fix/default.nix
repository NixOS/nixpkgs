{ lib, fetchFromGitLab, buildDunePackage }:

buildDunePackage rec {
  pname = "fix";
  version = "20220121";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = "fix";
    rev = "${version}";
    sha256 = "sha256-suWkZDLnXEO/4QCGmNuyLFOV0LJsFOMD13gxOcgu6JQ=";
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
