{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "hashcons";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "backtracking";
    repo = "ocaml-hashcons";
    rev = "d733325eeb55878bed285120c2c088daf78f0e2b";
    hash = "sha256-+KMmPj+DzuoofTXimxi0kXMPwqFwSnUHV81eMiTfl0A=";
  };

  doCheck = true;

  meta = {
    description = "OCaml hash-consing library";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
})
