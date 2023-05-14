{ lib, mkCoqDerivation, coq, hydra-battles, gaia,
  mathcomp-zify, mathcomp, version ? null }:

mkCoqDerivation rec {
  pname = "gaia-hydras";
  repo = "hydra-battles";

  release."0.5".sha256 = "121pcbn6v59l0c165ha9n00whbddpy11npx2y9cn7g879sfk2nqk";
  release."0.6".sha256 = "1dri4sisa7mhclf8w4kw7ixs5zxm8xyjr034r1377p96rdk3jj0j";
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion = with lib.versions; lib.switch [coq.coq-version mathcomp.version] [
    { cases = [ (range "8.14" "8.16") (isGe "1.12.0") ]; out = "0.6"; }
    { cases = [ (range "8.13" "8.14") (isGe "1.12.0") ]; out = "0.5"; }
  ] null;

  propagatedBuildInputs = [
    hydra-battles
    gaia
    mathcomp-zify
  ];

  useDune = true;

  meta = with lib; {
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
