{stdenv, fetchurl, ocaml, camlp4, cmdliner, cstruct, evtchn, findlib, gnt, io-page, ipaddr, lwt, mirage-types, sexplib, xenstore, xenstore-clients, libev, xen}:

stdenv.mkDerivation {
  name = "ocaml-vchan-1.0.0";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-vchan/archive/v1.0.0/ocaml-vchan-1.0.0.tar.gz";
    sha256 = "0dhm10cq2kr5dix8s0k3ldq46i5hk19im75pi1lv0ii4cixkqrk8";
  };

  buildInputs = [ ocaml camlp4 cmdliner cstruct evtchn findlib gnt io-page ipaddr lwt mirage-types sexplib xenstore xenstore-clients libev xen ];

  configurePhase = "true";

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_LDCONF=$OCAMLFIND_DESTDIR/ld.conf
    make install
    '';

  meta = {
    homepage = https://github.com/mirage/ocaml-vchan/;
    description = "OCaml implementation of the Xen Vchan protocol";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
