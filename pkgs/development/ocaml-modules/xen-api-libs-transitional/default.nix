{stdenv, fetchurl, forkexecd, ocaml, xen, camlp4, findlib, rpc, stdext, xcp-idl, xenstore, xenstore-clients, xmlm, uri, re, cohttp, message-switch, xcp-inventory, lwt}:

stdenv.mkDerivation {
  name = "ocaml-xen-api-libs-transitional-0.9.7";
  version = "0.9.7";

  src = fetchurl {
    url = "https://github.com/xapi-project/xen-api-libs-transitional/archive/v0.9.7/ocaml-xen-api-libs-transitional-0.9.7.tar.gz";
    sha256 = "0prcn5m986rwiaf359l2ds0k27qs5afg1r78h8pl8x938zjflm0f";
  };

  buildInputs = [ forkexecd ocaml xenstore camlp4 findlib rpc stdext xcp-idl xenstore-clients xmlm uri re cohttp message-switch xcp-inventory lwt xen ];

  configurePhase = ''
    ./configure
    '';

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install DESTDIR=$OCAMLFIND_DESTDIR
    '';

  meta = {
    homepage = https://github.com/xapi-project/xen-api-libs-transitional;
    description = "Deprecated standard library extension for OCaml";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
