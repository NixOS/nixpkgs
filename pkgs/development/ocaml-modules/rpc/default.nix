{stdenv, fetchurl, ocaml, camlp4, findlib, lwt, type_conv, xmlm, js_of_ocaml}:

stdenv.mkDerivation {
  name = "ocaml-rpc-1.5.1";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/samoht/ocaml-rpc/archive/1.5.1/ocaml-rpc-1.5.1.tar.gz";
    sha256 = "1q7mkrrzi1kzidlzqk8wdcx1zhf4l25fl91ajh04mdpzmlw05j25";
  };

  buildInputs = [ ocaml camlp4 findlib lwt js_of_ocaml ];

  propagatedBuildInputs = [ type_conv xmlm ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    make install
    '';

  meta = {
    homepage = https://github.com/samoht/ocaml-rpc;
    description = "An RPC library for OCaml";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
