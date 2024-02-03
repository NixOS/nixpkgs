{ coq, mkCoqDerivation, mathcomp, coqeal, mathcomp-real-closed,
  mathcomp-bigenough, mathcomp-zify, mathcomp-algebra-tactics,
  lib, version ? null }:

mkCoqDerivation {

  pname = "apery";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version mathcomp.version ]  [
      { cases = [ (range "8.13" "8.16") (range "1.12.0" "1.17.0") ]; out = "1.0.2"; }
    ] null;

  release."1.0.2".sha256 = "sha256-llxyMKYvWUA7fyroG1S/jtpioAoArmarR1edi3cikcY=";

  propagatedBuildInputs = [ mathcomp.field coqeal mathcomp-real-closed
    mathcomp-bigenough mathcomp-zify mathcomp-algebra-tactics ];

  meta = {
    description = "A formally verified proof in Coq, by computer algebra, that ζ(3) is irrational";
    license = lib.licenses.cecill-c;
  };
}
