{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "paco";
  owner = "snu-sf";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.6";         out = "4.0.2"; }
    { case = range "8.5" "8.8";  out = "1.2.8"; }
  ] null;
  release."4.0.2".sha256 = "1q96bsxclqx84xn5vkid501jkwlc1p6fhb8szrlrp82zglj58b0b";
  release."1.2.8".sha256 = "05fskx5x1qgaf9qv626m38y5izichzzqc7g2rglzrkygbskrrwsb";
  releaseRev = v: "v${v}";

  preBuild = "cd src";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Paco
    cp -pR *.vo $COQLIB/user-contrib/Paco
  '';

  meta = {
    homepage = "http://plv.mpi-sws.org/paco/";
    description = "A Coq library implementing parameterized coinduction";
    maintainers = with maintainers; [ jwiegley ptival ];
  };
}
