{ stdenv, buildDunePackage, fetchFromGitHub, ppx_deriving
, alcotest, biocaml, gnuplot, lacaml, menhir, ocaml-r, owl, printbox }:

buildDunePackage rec {
  pname = "phylogenetics";
  version = "unstable-2020-01-05";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "biocaml";
    repo   = pname;
    rev    = "b55ef7d7322bd822be26d21339945d45487fb547";
    sha256 = "0hzfjhs5w3a7hlzxs739k5ik3k1xn3dzyzziid765s74f638n4hj";
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
