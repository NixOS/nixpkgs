{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_sexp_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_custom_printf-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_custom_printf-113.33.00+4.03.tar.gz;
    sha256 = "1hw8q4x0hzyg3brlqpdm0bc7z6lnj6qymzw123cf51q9dq0386jb";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];
  propagatedBuildInputs = [ ppx_sexp_conv ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
