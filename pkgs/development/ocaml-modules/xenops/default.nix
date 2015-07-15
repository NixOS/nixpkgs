{stdenv, fetchurl, ocaml, xen, camlp4, cmdliner, findlib, obuild, xcp-idl, xen-api-libs-transitional, xenstore, xenstore-clients, uri, re, cohttp, xmlm, rpc, message-switch, fd-send-recv, xcp-inventory, lwt}:

stdenv.mkDerivation {
  name = "ocaml-xenops-0.9.6";
  version = "0.9.6";

  src = fetchurl {
    url = "https://github.com/xapi-project/xenops/archive/v0.9.6/ocaml-xenops-0.9.6.tar.gz";
    sha256 = "0pgkdz1ym942xdkcmly9xbrxblvd3689yfglm1qflv8dgbirs1r5";
  };

  buildInputs = [ ocaml xenstore camlp4 cmdliner findlib obuild xcp-idl xen-api-libs-transitional xenstore-clients uri re cohttp xmlm rpc message-switch fd-send-recv xcp-inventory lwt xen ];

  configurePhase = "true";

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $out/bin
    make install BINDIR=$out/bin
    '';

  meta = {
    homepage = https://github.com/xapi-project/xenops;
    description = "Low-level xen control operations OCaml";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
