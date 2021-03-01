{ lib, fetchurl, buildDunePackage, bigarray-compat, cstruct }:

buildDunePackage rec {
  pname = "hex";
  version = "1.4.0";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/hex-v${version}.tbz";
    sha256 = "07b9y0lmnflsslkrm6xilkj40n8sf2hjqkyqghnk7sw5l0plkqsp";
  };

  propagatedBuildInputs = [ bigarray-compat cstruct ];
  doCheck = true;

  meta = {
    description = "Mininal OCaml library providing hexadecimal converters";
    homepage = "https://github.com/mirage/ocaml-hex";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
