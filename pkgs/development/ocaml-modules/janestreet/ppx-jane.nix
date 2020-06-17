{stdenv, buildOcamlJane,
 ppx_assert,
 ppx_bench, ppx_bin_prot, ppx_compare, ppx_custom_printf, ppx_driver,
 ppx_enumerate, ppx_expect, ppx_fail, ppx_fields_conv, ppx_here,
 ppx_inline_test, ppx_let, ppx_pipebang, ppx_sexp_conv, ppx_sexp_message,
 ppx_sexp_value, ppx_typerep_conv, ppx_variants_conv}:

buildOcamlJane {
  name = "ppx_jane";
  hash  = "1la0rp8fhzfglwb15gqh1pl1ld8ls4cnidaw9mjc5q1hb0yj1qd9";
  propagatedBuildInputs =
    [ ppx_assert ppx_bench ppx_bin_prot ppx_compare ppx_custom_printf
      ppx_driver ppx_enumerate ppx_expect ppx_fail ppx_fields_conv
      ppx_here ppx_inline_test ppx_let ppx_pipebang ppx_sexp_conv
      ppx_sexp_message ppx_sexp_value ppx_typerep_conv ppx_variants_conv ];

  meta = with stdenv.lib; {
    description = "A ppx_driver including all standard ppx rewriters";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
