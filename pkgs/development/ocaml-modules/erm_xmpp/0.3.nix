{ stdenv, buildOcaml, fetchFromGitHub, ocaml, findlib, erm_xml, nocrypto }:

buildOcaml rec {
  version = "0.3";
  name = "erm_xmpp";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "xmpp";
    rev    = "eee18bd3dd343550169969c0b45548eafd51cfe1";
    sha256 = "0hzs528lrx1ayalv6fh555pjn0b4l8xch1f72hd3b07g1xahdas5";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ erm_xml nocrypto ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/hannesm/xmpp;
    description = "OCaml based XMPP implementation (fork)";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
