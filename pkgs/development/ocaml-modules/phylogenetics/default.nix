{ stdenv, buildDunePackage, fetchFromGitHub, ppx_deriving
, alcotest, biocaml, gnuplot, lacaml, menhir, owl }:

buildDunePackage rec {
  pname = "phylogenetics";
  version = "unstable-2019-11-15";

  src = fetchFromGitHub {
    owner  = "biocaml";
    repo   = pname;
    rev    = "91c03834db065cf4a86f33affbb9cfd216defc9f";
    sha256 = "0i9m0633a6a724as35ix8z3p1gj267cl0hmqrpw4qfq39zxmgnxb";
  };

  minimumOCamlVersion = "4.08";  # e.g., uses Float.min

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ biocaml gnuplot lacaml menhir owl ppx_deriving ];

  doCheck = false;  # many tests require bppsuite

  meta = with stdenv.lib; {
    inherit (std.meta) homepage;
    description = "Bioinformatics library for Ocaml";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.cecill-b;
  };
}
