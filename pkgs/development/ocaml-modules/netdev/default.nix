{stdenv, fetchurl, forkexecd, ocaml, findlib, stdext, uri, re, cohttp, message-switch, xcp-inventory}:

stdenv.mkDerivation {
  name = "ocaml-netdev-0.9.1";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/xapi-project/netdev/archive/v0.9.1/netdev-0.9.1.tar.gz";
    sha256 = "06jqww2zmrphgrv8cp195b7b8p5r79mazzsb7wx69vhsjxs8d394";
  };

  buildInputs = [ forkexecd ocaml findlib stdext uri re cohttp message-switch xcp-inventory ];

  configurePhase = ''
    ./configure
    '';

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/netdev;
    description = "Manipulate Linux bridges, network devices and openvswitch instances in OCaml";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
