{ stdenv, fetchurl, ocaml, findlib, ocaml_lwt, ocaml_typeconv, xmlm, camlp4 }:

let version = "1.5.1"; in
stdenv.mkDerivation {
  name = "rpc-${version}";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-rpc/archive/${version}.tar.gz";
    sha256 = "1q7mkrrzi1kzidlzqk8wdcx1zhf4l25fl91ajh04mdpzmlw05j25";
  };

  buildInputs = [ ocaml findlib ocaml_lwt ocaml_typeconv xmlm camlp4 ];

  createFindlibDestdir = true;
  
  meta = with stdenv.lib;
    { description = "Library to deal with RPCs in OCaml";
      maintainers = with maintainers; [ emery ];
    };
}
