{ lib, fetchurl, buildDunePackage, cstruct, bigarray-compat }:

buildDunePackage rec {
  minimumOCamlVersion = "4.03";
  pname = "eqaf";
  version = "0.7";

  src = fetchurl {
    url = "https://github.com/mirage/eqaf/releases/download/v${version}/eqaf-v${version}.tbz";
    sha256 = "1q09pwhs121vpficl2af1yzs4y7dd9bc1lcxbqyfc4x4m6p6drhh";
  };

  propagatedBuildInputs = [ cstruct bigarray-compat ];

  meta = {
    description = "Constant time equal function to avoid timing attacks in OCaml";
    homepage = "https://github.com/mirage/eqaf";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
