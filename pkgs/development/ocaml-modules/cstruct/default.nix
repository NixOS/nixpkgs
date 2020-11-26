{ lib, fetchurl, buildDunePackage, bigarray-compat }:

buildDunePackage rec {
  pname = "cstruct";
  version = "5.0.0";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-v${version}.tbz";
    sha256 = "1z403q2nkgz5x07j0ypy6q0mk2yxgqbp1jlqkngbajna7124x2pb";
  };

  propagatedBuildInputs = [ bigarray-compat ];

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
