{stdenv, fetchurl, ocaml, cmdliner, crc, cstruct, findlib, gnt, xcp-idl, xcp-rrd, uri, re, cohttp, message-switch, xcp-inventory, io-page, lwt, xen, libev}:

stdenv.mkDerivation {
  name = "ocaml-rrd-transport-0.7.2";
  version = "0.7.2";

  src = fetchurl {
    url = "https://github.com/xapi-project/rrd-transport/archive/0.7.2/ocaml-rrd-transport-0.7.2.tar.gz";
    sha256 = "1sik59a35lswzsns1hmzhdyddgrm87ih03k2wyvhdg2624dv0hxg";
  };

  buildInputs = [ ocaml cmdliner cstruct findlib xcp-idl xcp-rrd uri re cohttp message-switch xcp-inventory io-page lwt xen libev ];

  propagatedBuildInputs = [ crc gnt ];

  configurePhase = ''
    ocaml setup.ml -configure --destdir $out
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_LDCONF=$OCAMLFIND_DESTDIR/ld.conf
    ocaml setup.ml -install
    '';

  meta = {
    homepage = https://github.com/xapi-project/rrd-transport/;
    description = "Shared-memory protocols for transmitting RRD data";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
