{ stdenv, buildDunePackage, fetchFromGitHub, ppx_deriving
, alcotest, biocaml, gnuplot, lacaml, menhir, ocaml-r, owl, printbox }:

buildDunePackage rec {
  pname = "phylogenetics";
  version = "unstable-2020-01-25";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "biocaml";
    repo   = pname;
    rev    = "752a7d0324709ba919ef43630a270afd45d6b734";
    sha256 = "1zsxpl1yjbw6y6n1q7qk3h0l7c0lxhh8yp8bkxlwnpzlkqq28ycg";
  };

  minimumOCamlVersion = "4.08";  # e.g., uses Float.min

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ biocaml gnuplot lacaml menhir ocaml-r owl ppx_deriving printbox ];

  doCheck = false;  # many tests require bppsuite

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Bioinformatics library for Ocaml";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.cecill-b;
  };
}
