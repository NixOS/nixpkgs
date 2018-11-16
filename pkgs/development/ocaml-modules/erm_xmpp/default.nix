{ stdenv, fetchFromGitHub, ocaml, findlib, camlp4, ocamlbuild
, erm_xml, nocrypto
}:

stdenv.mkDerivation rec {
  version = "0.3+20180112";
  name = "ocaml${ocaml.version}-erm_xmpp-${version}";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "xmpp";
    rev    = "184dc70fab7d46d09b9148ca4448f07f1e0a2df2";
    sha256 = "1dsqsfacvd9xqsqjzh6xwbnf2mv1dvhy210riyvjd260q085ch6n";
  };

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ];
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
    inherit (ocaml.meta) platforms;
  };
}
