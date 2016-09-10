{stdenv, fetchurl, ocaml, camlp4, cstruct, findlib, lwt, ounit, libev}:

stdenv.mkDerivation {
  name = "ocaml-shared-memory-ring-1.1.0";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/shared-memory-ring/archive/1.1.0/ocaml-shared-memory-ring-1.1.0.tar.gz";
    sha256 = "0cpbin6ciiy47fwnc2nwpglmgrzz4ckqf9m8i02kxl7dr8s7ka4k";
  };

  buildInputs = [ ocaml camlp4 cstruct findlib lwt ounit libev ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_LDCONF=$OCAMLFIND_DESTDIR/ld.conf
    make install
    '';

  meta = {
    homepage = https://github.com/mirage/shared-memory-ring/;
    description = "OCaml implementation of Xen shared memory rings";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
