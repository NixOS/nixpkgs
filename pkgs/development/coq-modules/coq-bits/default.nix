{ lib, mkCoqDerivation, coq, mathcomp, version ? null }:

with lib; mkCoqDerivation {
  pname = "coq-bits";
  repo = "bits";
  inherit version;
  defaultVersion =
    if versions.isGe "8.10" coq.version
    then "1.1.0"
    else if versions.isGe "8.7" coq.version
    then "1.0.0"
    else null;

  release = {
    "1.0.0" = {
      rev = "1.0.0";
      sha256 = "0nv5mdgrd075dpd8bc7h0xc5i95v0pkm0bfyq5rj6ii1s54dwcjl";
    };
    "1.1.0" = {
      rev = "1.1.0";
      sha256 = "sha256-TCw1kSXeW0ysIdLeNr+EGmpGumEE9i8tinEMp57UXaE=";
    };
  };

  extraBuildInputs = [ mathcomp.ssreflect mathcomp.fingroup ];
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
