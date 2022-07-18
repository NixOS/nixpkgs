{ lib, fetchurl, buildDunePackage, cstruct, bigarray-compat }:

buildDunePackage rec {
  minimumOCamlVersion = "4.03";
  pname = "eqaf";
  version = "0.8";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/eqaf/releases/download/v${version}/eqaf-v${version}.tbz";
    sha256 = "sha256-EUWhYBB0N9eUPgLkht9r0jPTk37BpZfX+jntuUcc+HU=";
  };

  propagatedBuildInputs = [ cstruct bigarray-compat ];

  meta = {
    description = "Constant time equal function to avoid timing attacks in OCaml";
    homepage = "https://github.com/mirage/eqaf";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
