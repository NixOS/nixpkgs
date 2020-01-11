{ buildDunePackage, lib, fetchurl, ocaml }:

buildDunePackage rec {
  pname = "stdlib-shims";
  version = "0.1.0";
  src = fetchurl {
    url = "https://github.com/ocaml/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1jv6yb47f66239m7hsz7zzw3i48mjpbvfgpszws48apqx63wjwsk";
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
