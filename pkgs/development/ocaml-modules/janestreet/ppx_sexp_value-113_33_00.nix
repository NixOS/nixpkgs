{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_here, ppx_sexp_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_sexp_value-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_sexp_value-113.33.00+4.03.tar.gz;
    sha256 = "0pn2v1m479lbdgprv4w9czyv5nim0hz6ailmy1xxlxlhazwbqzwm";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];
  propagatedBuildInputs = [ ppx_sexp_conv ppx_here ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
