{ stdenv, fetchurl, ocaml, ocamlbuild, findlib
, dune, sexplib, ppx_sexp_conv
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ipaddr-${version}";
  version = "2.8.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/archive/${version}.tar.gz";
    sha256 = "1amb1pbm9ybpxy6190qygpj6nmbzzs2r6vx4xh5r6v89szx9rfxw";
  };

  buildInputs = [ ocaml findlib ocamlbuild dune ];
  propagatedBuildInputs = [ ppx_sexp_conv sexplib ];

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-ipaddr;
    description = "A library for manipulation of IP (and MAC) address representations ";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
