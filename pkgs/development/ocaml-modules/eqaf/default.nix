{ lib, fetchurl, buildDunePackage, cstruct }:

buildDunePackage rec {
  minimalOCamlVersion = "4.07";
  duneVersion = "3";
  pname = "eqaf";
  version = "0.10";

  src = fetchurl {
    url = "https://github.com/mirage/eqaf/releases/download/v${version}/eqaf-${version}.tbz";
    hash = "sha256-Z9E2nFfE0tFKENAmMtReNVIkq+uYrsCJecC65YQwku4=";
  };

  propagatedBuildInputs = [ cstruct ];

  meta = {
    description = "Constant time equal function to avoid timing attacks in OCaml";
    homepage = "https://github.com/mirage/eqaf";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
