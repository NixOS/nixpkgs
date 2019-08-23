{ stdenv, fetchurl, buildDunePackage, sexplib, ocplib-endian }:

buildDunePackage rec {
  pname = "cstruct";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-${version}.tbz";
    sha256 = "1x4jxsvd1lrfibnjdjrkfl7hqsc48rljnwbap6faanj9qhwwa6v2";
  };

  propagatedBuildInputs = [ sexplib ocplib-endian ];

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = stdenv.lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
