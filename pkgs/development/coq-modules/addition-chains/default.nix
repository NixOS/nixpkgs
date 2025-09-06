{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp-ssreflect,
  mathcomp-algebra,
  mathcomp-fingroup,
  paramcoq,
  version ? null,
}:

mkCoqDerivation {
  pname = "addition-chains";
  repo = "hydra-battles";

  release."0.4".hash = "sha256-l+JtfRwN46Fx7rhacbwIfQVAzqGlSwduYiTHOThh97g=";
  release."0.5".hash = "sha256-E1sxnU4HvWNZ8qJfG4K/rS3IAbBJwWICAzSVbexiN4g=";
  release."0.6".hash = "sha256-Ekg5Zssm3XNGyGSALH1Htf+iezx8Eo4cZbAepaMmMbc=";
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = range "8.13" "8.18";
        out = "0.6";
      }
      {
        case = range "8.11" "8.12";
        out = "0.4";
      }
    ] null;

  propagatedBuildInputs = [
    mathcomp-ssreflect
    mathcomp-algebra
    mathcomp-fingroup
    paramcoq
  ];

  useDune = true;

  meta = with lib; {
    description = "Exponentiation algorithms following addition chains";
    longDescription = ''
      Addition chains are algorithms for computations of the p-th
      power of some x, with the least number of multiplication as
      possible. We present a few implementations of addition chains,
      with proofs of their correctness.
    '';
    maintainers = with maintainers; [ Zimmi48 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
