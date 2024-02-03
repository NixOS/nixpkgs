{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "paco";
  owner = "snu-sf";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.13" "8.19"; out = "4.2.0"; }
    { case = range "8.12" "8.17"; out = "4.1.2"; }
    { case = range "8.9" "8.13"; out = "4.1.1"; }
    { case = range "8.6" "8.13"; out = "4.0.2"; }
    { case = isEq "8.5";         out = "1.2.8"; }
  ] null;
  release."4.2.0".sha256 = "sha256-YHYtiz9hium96n3owL/C99AjJAFTlTCmmb2+ttevgMY=";
  release."4.1.2".sha256 = "sha256:1l8mwakqp4wnppsldl8wp2j24h1jvadnvrsgf35xnvdyygypjp2v";
  release."4.1.1".sha256 = "1qap8cyv649lr1s11r7h5jzdjd4hsna8kph15qy5fw24h5nx6byy";
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
    homepage = "https://plv.mpi-sws.org/paco/";
    description = "A Coq library implementing parameterized coinduction";
    maintainers = with lib.maintainers; [ jwiegley ptival ];
  };
}
