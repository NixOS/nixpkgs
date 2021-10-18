{ lib, mkCoqDerivation, coq, hydra-battles, gaia, mathcomp-zify, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "gaia-hydras";
  repo = "hydra-battles";

  release."0.5".sha256 = "121pcbn6v59l0c165ha9n00whbddpy11npx2y9cn7g879sfk2nqk";
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.13" "8.14"; out = "0.5"; }
  ] null;

  propagatedBuildInputs = [
    hydra-battles
    gaia
    mathcomp-zify
  ];

  useDune2 = true;

  meta = {
    description = "Comparison between ordinals in Gaia and Hydra battles";
    longDescription = ''
      The Gaia and Hydra battles projects develop different notions of ordinals.
      This development bridges the different notions.
    '';
    maintainers = with maintainers; [ Zimmi48 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
