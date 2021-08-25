{ lib, mkCoqDerivation, coq, mathcomp-ssreflect, mathcomp-algebra, paramcoq
, version ? null }:
with lib;

mkCoqDerivation {
  pname = "addition-chains";
  repo = "hydra-battles";

  release."0.4".sha256 = "sha256:1f7pc4w3kir4c9p0fjx5l77401bx12y72nmqxrqs3qqd3iynvqlp";
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.11"; out = "0.4"; }
  ] null;

  propagatedBuildInputs = [ mathcomp-ssreflect mathcomp-algebra paramcoq ];

  useDune2 = true;

  meta = {
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
