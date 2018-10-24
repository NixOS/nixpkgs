{ stdenv, fetchFromGitHub, ocaml, findlib, dune, doc-ock, tyxml, xmlm }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-doc-ock-html-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ocaml-doc";
    repo = "doc-ock-html";
    rev = "v${version}";
    sha256 = "1y620h48qrplmcm78g7c78zibpkai4j3icwmnx95zb3r8xq8554y";
  };

  buildInputs = [ ocaml findlib dune ];

  propagatedBuildInputs = [ doc-ock tyxml xmlm ];

  inherit (dune) installPhase;

  meta = {
    description = "From doc-ock to HTML";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
