{stdenv, fetchurl, ocaml, xen, camlp4, cmdliner, cstruct, findlib, io-page, lwt, libev}:

stdenv.mkDerivation {
  name = "ocaml-evtchn-1.0.5";
  version = "1.0.5";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-evtchn/archive/v1.0.5/ocaml-evtchn-1.0.5.tar.gz";
    sha256 = "0n7hz0mmg4ibchvpp0hzicky0gy1515hrhpsl9csybfmqxmmbqfa";
  };

  buildInputs = [ ocaml xen camlp4 cmdliner cstruct findlib io-page lwt libev ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_LDCONF=$OCAMLFIND_DESTDIR/ld.conf
    make install
    '';

  meta = {
    homepage = https://github.com/mirage/ocaml-evtchn/;
    description = "OCaml bindings for userspace Xen event channel controls";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
