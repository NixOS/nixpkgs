{ lib, mkCoqDerivation, coq, interval, compcert, flocq, bignums, version ? null }:

with lib; mkCoqDerivation {
  pname = "vcfloat";
  owner = "VeriNum";
  inherit version;
  sourceRoot = "source/vcfloat";
  postPatch = ''
    coq_makefile -o Makefile -f _CoqProject *.v
  '';
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.16" "8.17"; out = "2.1.1"; }
  ] null;
  release."2.1.1".sha256 = "sha256-bd/XSQhyFUAnSm2bhZEZBWB6l4/Ptlm9JrWu6w9BOpw=";
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ interval compcert flocq bignums ];

  meta = {
    description = "A tool for Coq proofs about floating-point round-off error";
    maintainers = with maintainers; [ quinn-dougherty ];
    license = licenses.lgpl3Plus;
  };
}
