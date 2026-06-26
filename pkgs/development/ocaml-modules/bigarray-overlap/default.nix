{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
  pkg-config,
}:

buildDunePackage (finalAttrs: {
  pname = "bigarray-overlap";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/dinosaure/overlap/releases/download/v${finalAttrs.version}/bigarray-overlap-${finalAttrs.version}.tbz";
    hash = "sha256-L1IKxHAFTjNYg+upJUvyi2Z23bV3U8+1iyLPhK4aZuA=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  nativeBuildInputs = [ pkg-config ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/dinosaure/overlap";
    description = "Minimal library to know that 2 bigarray share physically the same memory or not";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
