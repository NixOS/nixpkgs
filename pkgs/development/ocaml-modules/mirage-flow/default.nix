{
  lib,
  buildDunePackage,
  fetchurl,
  cstruct,
  fmt,
  lwt,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "mirage-flow";
  version = "5.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-flow/releases/download/v${finalAttrs.version}/mirage-flow-${finalAttrs.version}.tbz";
    hash = "sha256-N8p5yuDtmycLh3Eu3LOXpd7Eqzk1eygQfgDapshVMyM=";
=======
buildDunePackage rec {
  pname = "mirage-flow";
  version = "4.0.2";

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-flow/releases/download/v${version}/mirage-flow-${version}.tbz";
    hash = "sha256-SGXj3S4b53O9JENUFuMl3I+QoiZ0QSrYu7zTet7q+1o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    cstruct
    fmt
    lwt
  ];

  meta = {
    description = "Flow implementations and combinators for MirageOS";
    homepage = "https://github.com/mirage/mirage-flow";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
