{ stdenv, buildOcaml, fetchurl, ocamlbuild, findlib
, topkg, sexplib, ppx_sexp_conv, opam }:

buildOcaml rec {
  name = "ipaddr";
  version = "2.7.2";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/archive/${version}.tar.gz";
    sha256 = "0mnjw1xjr8vyn5x1nnbbxfxhs77znwrkz8c144w47zk2pc3xrh9d";
  };

  buildInputs = [ findlib ocamlbuild topkg ppx_sexp_conv opam ];
  propagatedBuildInputs = [ sexplib ];

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-ipaddr;
    description = "A library for manipulation of IP (and MAC) address representations ";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
