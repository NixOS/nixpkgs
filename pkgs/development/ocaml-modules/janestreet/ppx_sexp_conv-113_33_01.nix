{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, sexplib, ppx_deriving, ppx_tools, ppx_type_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_sexp_conv-133.33.01+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_sexp_conv-113.33.01+4.03.tar.gz;
    sha256 = "176pydk5fs8m2md9v8v5b16gra90s4v0ssqq38ghfsbv1faca8d6";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ sexplib ppx_deriving ppx_type_conv ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
