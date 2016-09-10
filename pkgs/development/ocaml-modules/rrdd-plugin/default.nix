{stdenv, fetchurl, forkexecd, ocaml, findlib, rrd-transport, stdext, xcp-idl, xcp-rrd, xenstore, xenstore-clients, uri, re, cohttp, message-switch, xcp-inventory, xen, libev}:

stdenv.mkDerivation {
  name = "ocaml-rrdd-plugin-0.6.1";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-rrdd-plugin/archive/0.6.1/ocaml-rrdd-plugin-0.6.1.tar.gz";
    sha256 = "1qza2afg6dmfjxbhb8qdjs28p0mim4g8sdbjcm7722chd97yp39m";
  };

  buildInputs = [ forkexecd ocaml findlib stdext xcp-idl xcp-rrd xenstore xenstore-clients uri re cohttp message-switch xcp-inventory xen libev ];

  propagatedBuildInputs = [ rrd-transport ];

  configurePhase = "true";

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/ocaml-rrdd-plugin/;
    description = "Plugin library for the XenServer RRD daemon";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
