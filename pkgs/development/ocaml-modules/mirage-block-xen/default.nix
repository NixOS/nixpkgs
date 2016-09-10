{stdenv, fetchurl, ocaml, camlp4, cmdliner, cstruct, evtchn, findlib, gnt, io-page, ipaddr, lwt, mirage-types, mirage-xen, shared-memory-ring}:

stdenv.mkDerivation {
  name = "ocaml-mirage-block-xen-1.1.0";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-block-xen/archive/v1.1.0/ocaml-mirage-block-xen-1.1.0.tar.gz";
    sha256 = "00bw6dgzz0x75zxxrp17i28i2ykcg706zp7l82vfv5v899qmvarb";
  };

  buildInputs = [ ocaml camlp4 cmdliner cstruct evtchn findlib gnt io-page ipaddr lwt mirage-types mirage-xen shared-memory-ring ];

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
    homepage = https://github.com/mirage/mirage-block-xen/;
    description = "Mirage block driver for Xen that implements the blkfront/back protocol";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
