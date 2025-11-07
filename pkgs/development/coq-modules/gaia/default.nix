{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "gaia";

  release."1.11".sha256 = "sha256:0gwb0blf37sv9gb0qpn34dab71zdcx7jsnqm3j9p58qw65cgsqn5";
  release."1.12".sha256 = "sha256:0c6cim4x6f9944g8v0cp0lxs244lrhb04ms4y2s6y1wh321zj5mi";
  release."1.13".sha256 = "sha256:0i8ix2rbw10v34bi0yrx0z89ng96ydqbxm8rv2rnfgy4d1b27x6q";
  release."1.14".sha256 = "sha256-wgeQC0fIN3PSmRY1K6/KTy+rJmqqxdo3Bhsz1vjVAes=";
  release."1.15".sha256 = "sha256:04zchnkvaq2mzpcilpspn5l947689gj3m0w20m0nd7w4drvlahnw";
  release."1.17".sha256 = "sha256-2VzdopXgKS/wC5Rd1/Zlr12J5bSIGINFjG1nrMjDrGE=";
  release."2.2".sha256 = "sha256-y8LlQg9d9rfPFjzS9Xu3BW/H3tPiOC+Eb/zwXJGW9d4=";
  release."2.3".sha256 = "sha256-inWJok0F3SZpVfoyMfpRXHVHn4z2aY8JjCKKhdVTnoc=";
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ coq.coq-version mathcomp.version ]
      [
        (case (range "8.16" "9.1") (range "2.0" "2.4") "2.3")
        (case (range "8.16" "9.0") (range "2.0" "2.3") "2.2")
        (case (range "8.10" "8.18") (range "1.12.0" "1.18.0") "1.17")
        (case (range "8.10" "8.12") "1.11.0" "1.11")
      ]
      null;

  propagatedBuildInputs = [
    mathcomp.boot
    mathcomp.fingroup
    mathcomp.algebra
    stdlib
  ];

  meta = with lib; {
    description = "Implementation of books from Bourbaki's Elements of Mathematics in Coq";
    maintainers = with maintainers; [ Zimmi48 ];
    license = licenses.mit;
  };
}
