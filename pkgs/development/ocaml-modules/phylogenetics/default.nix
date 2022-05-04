{ lib
, buildDunePackage
, fetchurl
, ppx_deriving
, bppsuite
, alcotest
, angstrom-unix
, biocaml
, core
, gsl
, lacaml
, menhir
, menhirLib
, printbox-text
}:

buildDunePackage rec {
  pname = "phylogenetics";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/biocaml/phylogenetics/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "sha256:064ldljzh17h8pp0c27xd1pf6c50yhccw2g3hddzhk07a95q8v16";
  };

  # Ensure compatibility with printbox ≥ 0.6
  preConfigure = ''
    substituteInPlace lib/dune --replace printbox printbox-text
  '';

  minimalOCamlVersion = "4.08";

  checkInputs = [ alcotest bppsuite ];
  buildInputs = [ menhir ];
  propagatedBuildInputs = [
    angstrom-unix
    biocaml
    core
    gsl
    lacaml
    menhirLib
    ppx_deriving
    printbox-text
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/biocaml/phylogenetics";
    description = "Algorithms and datastructures for phylogenetics";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.cecill-b;
  };
}
