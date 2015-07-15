{stdenv, fetchurl, message-switch, ocaml, camlp4, cmdliner, cohttp, fd-send-recv, findlib, ounit, rpc, sexplib, xcp-inventory, xcp-rrd, xmlm, lwt, libev}:

stdenv.mkDerivation {
  name = "ocaml-xcp-idl-0.9.21";
  version = "0.9.21";

  src = fetchurl {
    url = "https://github.com/xapi-project/xcp-idl/archive/v0.9.21/xcp-idl-0.9.21.tar.gz";
    sha256 = "14d537cn6a9lmkrxad2gxlll2ix99qhr58w5z0dvdpcrmyqbkgf2";
  };

  buildInputs = [ message-switch ocaml camlp4 cmdliner cohttp fd-send-recv findlib ounit rpc sexplib xcp-inventory xcp-rrd xmlm lwt libev];

  configurePhase = ''
    ocaml setup.ml -configure
    '';

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/xcp-idl;
    description = "Common interface definitions for XCP services";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
