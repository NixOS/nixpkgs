{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, variantslib, ppx_deriving, ppx_type_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_variants_conv-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_variants_conv-113.33.00+4.03.tar.gz;
    sha256 = "0il0nkdwwsc1ymshj4q9nzw5ixm12ls0jj7z3q16k48bg3z5ibc0";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];
  propagatedBuildInputs = [ variantslib ppx_deriving ppx_type_conv ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
