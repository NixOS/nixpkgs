{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "cstruct";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-v${version}.tbz";
    sha256 = "1q4fsc2m6d96yf42g3wb3gcnhpnxw800df5mh3yr25pprj8y4m1a";
  };

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
