{stdenv, fetchurl, ocaml, camlp4, evtchn, findlib, gnt, mirage-types, mirage-xen, io-page, lwt}:

stdenv.mkDerivation {
  name = "ocaml-mirage-console-xen-1.0.2";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-console/archive/v1.0.2/ocaml-mirage-console-xen-1.0.2.tar.gz";
    sha256 = "14bawi5hqfrjjl3djx712z5qpgm088mbfw2wdh230avh7p8i293a";
  };

  buildInputs = [ ocaml camlp4 evtchn findlib gnt mirage-types mirage-xen io-page lwt ];

  configurePhase = "true";

  buildPhase = ''
    make xen-build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make xen-install
    '';

  meta = {
    homepage = https://github.com/mirage/mirage-console/;
    description = "A Mirage-compatible Console library for Xen";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
