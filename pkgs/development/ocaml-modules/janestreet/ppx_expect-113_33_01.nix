{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_driver, ppx_assert, ppx_custom_printf, ppx_inline_test
, ppx_fields_conv, ppx_variants_conv, re, sexplib, fieldslib
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_expect-113.33.01+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_expect-113.33.01+4.03.tar.gz;
    sha256 = "1r358vx3wnkzq8kwgi49400l1fx2bnl6gds4hl7s67lxsqxki2z7";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_assert ppx_custom_printf ppx_fields_conv ppx_variants_conv re ];
  propagatedBuildInputs = [ ppx_driver ppx_inline_test fieldslib sexplib ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
