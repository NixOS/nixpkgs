{ lib, mkCoqDerivation, autoconf, automake, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "HoTT";
  repo = "Coq-HoTT";
  owner = "HoTT";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.14" "8.16"; out = coq.coq-version; }
  ] null;
  releaseRev = v: "V${v}";
  release."8.16".sha256 = "sha256-xcEbz4ZQ+U7mb0SEJopaczfoRc2GSgF2BGzUSWI0/HY=";
  release."8.15".sha256 = "sha256-JfeiRZVnrjn3SQ87y6dj9DWNwCzrkK3HBogeZARUn9g=";
  release."8.14".sha256 = "sha256-7kXk2pmYsTNodHA+Qts3BoMsewvzmCbYvxw9Sgwyvq0=";

  patchPhase = ''
    patchShebangs etc
  '';

  meta = {
    homepage = "https://homotopytypetheory.org/";
    description = "Homotopy type theory";
    maintainers = with maintainers; [ siddharthist ];
  };
}
