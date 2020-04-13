{ buildDunePackage, lib, fetchurl, ocaml }:

buildDunePackage rec {
  pname = "stdlib-shims";
  version = "0.2.0";
  src = fetchurl {
    url = "https://github.com/ocaml/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "0nb5flrczpqla1jy2pcsxm06w4jhc7lgbpik11amwhfzdriz0n9c";
  };
  minimumOCamlVersion = "4.02";
  doCheck = true;
  meta = {
    description = "Shims for forward-compatibility between versions of the OCaml standard library";
    homepage = "https://github.com/ocaml/stdlib-shims";
    inherit (ocaml.meta) license;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
