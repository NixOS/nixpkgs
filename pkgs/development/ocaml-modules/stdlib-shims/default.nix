{ buildDunePackage, lib, fetchurl, ocaml }:

buildDunePackage rec {
  pname = "stdlib-shims";
  version = "0.3.0";
  src = fetchurl {
    url = "https://github.com/ocaml/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "sha256-ur9y05F7hvcHiF8MVSjjbGP8y2mPS0bPK6tcfM3W2Eo=";
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
