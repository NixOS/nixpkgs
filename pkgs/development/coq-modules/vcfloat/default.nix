{ lib, mkCoqDerivation, coq, interval, compcert, flocq, bignums, version ? null }:

let self = mkCoqDerivation {
  pname = "vcfloat";
  owner = "VeriNum";
  inherit version;
  sourceRoot = "${self.src.name}/vcfloat";
  postPatch = ''
    coq_makefile -o Makefile -f _CoqProject *.v
  '';
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = isEq "8.19"; out = "2.2"; }
    { case = range "8.16" "8.18"; out = "2.1.1"; }
  ] null;
  release."2.2".sha256 = "sha256-PyMm84ZYh+dOnl8Kk2wlYsQ+S/d1Hsp6uv2twTedEPg=";
  release."2.1.1".sha256 = "sha256-bd/XSQhyFUAnSm2bhZEZBWB6l4/Ptlm9JrWu6w9BOpw=";
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ interval compcert flocq bignums ];

  meta = {
    description = "Tool for Coq proofs about floating-point round-off error";
    maintainers = with lib.maintainers; [ quinn-dougherty ];
    license = lib.licenses.lgpl3Plus;
  };
};
in self
