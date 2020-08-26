{ stdenv, fetchFromGitHub, ocaml, findlib, camlp4, ocamlbuild
, erm_xml, mirage-crypto, mirage-crypto-rng, base64
}:

stdenv.mkDerivation rec {
  version = "0.3+20200317";
  name = "ocaml${ocaml.version}-erm_xmpp-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "xmpp";
    rev    = "7fa5bea252671fd88625c6af109998b879ca564f";
    sha256 = "0spzyd9kbyizzwl8y3mq8z19zlkzxnkh2fppry4lyc7vaw7bqrwq";
  };

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ];
  propagatedBuildInputs = [ erm_xml mirage-crypto mirage-crypto-rng base64 ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/hannesm/xmpp";
    description = "OCaml based XMPP implementation (fork)";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
    inherit (ocaml.meta) platforms;
  };
}
