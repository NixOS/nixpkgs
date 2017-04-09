{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_assert, ppx_bench, ppx_bin_prot, ppx_custom_printf, ppx_enumerate, ppx_expect, ppx_fail, ppx_fields_conv, ppx_let, ppx_pipebang, ppx_sexp_message, ppx_sexp_value, ppx_typerep_conv, ppx_variants_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_jane-113.33.00";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_jane-113.33.00.tar.gz;
    sha256 = "15lbrc9jj83k208gv7knz7mk9xh9mdb657jdjb1006gdsskfmra6";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];
  propagatedBuildInputs = [ ppx_assert ppx_bench ppx_bin_prot
    ppx_custom_printf ppx_enumerate ppx_expect ppx_fail ppx_fields_conv
    ppx_let ppx_pipebang ppx_sexp_message ppx_sexp_value ppx_typerep_conv
    ppx_variants_conv ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
