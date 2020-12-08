{ stdenv, buildDunePackage, fetchFromGitHub, ppx_deriving
, alcotest, angstrom-unix, biocaml, gnuplot, gsl, lacaml, menhir, owl, printbox }:

buildDunePackage rec {
  pname = "phylogenetics";
  version = "unstable-2020-11-23";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "biocaml";
    repo   = pname;
    rev    = "e6e10efa0a3a8fd61bf4ab69e91a09549cc1ded6";
    sha256 = "0pmypzp0rvlpzm8zpbcfkphwnhrpyfwfv44kshvx2f8nslmksh8c";
  };

  minimumOCamlVersion = "4.08";  # e.g., uses Float.min

  checkInputs = [ alcotest ];
  buildInputs = [ menhir ];
  propagatedBuildInputs = [ angstrom-unix biocaml gnuplot gsl lacaml owl ppx_deriving printbox ];

  doCheck = false;  # many tests require bppsuite

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Bioinformatics library for Ocaml";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.cecill-b;
  };
}
