{ stdenv, fetchurl, fetchzip, ocaml, findlib, erm_xml, cryptokit, camlp4 }:

let
  version = "0.2";
  disable-tests = fetchurl {
    url = https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/erm_xmpp/erm_xmpp.0.2/files/disable_tests.patch;
    sha256 = "09d8630nmx2x8kb8ap1zmsb93zs14cqg7ga1gmdl92jvsjxbhgc1";
  };
in

stdenv.mkDerivation {
  name = "ocaml-erm_xmpp-${version}";

  src = fetchzip {
    url = "https://github.com/ermine/xmpp/archive/v${version}.tar.gz";
    sha256 = "0saw2dmrzv2aadrznvyvchnhivvcwm78x9nwf6flq5v0pqddapk2";
  };

  patches = [ disable-tests ];

  buildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ erm_xml cryptokit ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/ermine/xmpp;
    description = "OCaml based XMPP implementation";
    platforms = ocaml.meta.platforms or [];
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
