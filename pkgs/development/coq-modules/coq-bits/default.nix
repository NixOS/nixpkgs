{ lib, mkCoqDerivation, coq, mathcomp, version ? null }:

with lib; mkCoqDerivation {
  pname = "coq-bits";
  repo = "bits";
  inherit version;
  defaultVersion = if versions.isGe "8.7" coq.version then "20190812" else null;

  release."20190812".rev    = "1.0.0";
  release."20190812".sha256 = "0nv5mdgrd075dpd8bc7h0xc5i95v0pkm0bfyq5rj6ii1s54dwcjl";

  propagatedBuildInputs = [ mathcomp.algebra ];

  installPhase = ''
    make -f Makefile CoqMakefile
    make -f CoqMakefile COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = {
    description = "A formalization of bitset operations in Coq";
    license = licenses.asl20;
    maintainers = with maintainers; [ ptival ];
  };
}
