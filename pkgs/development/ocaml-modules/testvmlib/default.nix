{stdenv, fetchurl, ocaml, xen, camlp4, cmdliner, cohttp, cstruct, evtchn, findlib, gnt, io-page, ipaddr, lwt, mirage, mirage-types, rpc, vchan, xenstore, xenstore-clients, libev}:

stdenv.mkDerivation {
  name = "ocaml-testvmlib-0.3";
  version = "0.3";

  src = fetchurl {
    url = "https://github.com/mirage/testvm-idl/archive/v0.3/ocaml-testvmlib-0.3.tar.gz";
    sha256 = "1gc850lm33s3vdlwh8wl487bqlryik6kmvl4dj6z8ai9g2kmlwq9";
  };

  buildInputs = [ ocaml camlp4 cmdliner cstruct evtchn findlib gnt io-page ipaddr lwt mirage-types xenstore xenstore-clients xen vchan libev ];

  propagatedBuildInputs = [ mirage cohttp rpc ];

  configurePhase = "true";

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_LDCONF=$OCAMLFIND_DESTDIR/ld.conf
    make install
    mkdir $out/bin
    cp client.native $out/bin/mirage-testvm-cli
    '';

  meta = {
    homepage = https://github.com/mirage/testvm-idl/;
    description = "Mirage test VM library";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
