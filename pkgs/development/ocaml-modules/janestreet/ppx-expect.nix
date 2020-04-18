{stdenv, buildOcamlJane,
 ppx_assert, ppx_compare, ppx_core, ppx_custom_printf, ppx_driver,
 ppx_fields_conv, ppx_here, ppx_inline_test, ppx_sexp_conv, ppx_tools,
 ppx_variants_conv, re, sexplib, variantslib, fieldslib}:

buildOcamlJane {
  name = "ppx_expect";
  hash = "0cwagb4cj3x1vsr19kyfa9pxlvaz9a5v863cahi5glinsh4mzgdx";
  propagatedBuildInputs =
    [ ppx_assert ppx_compare ppx_core ppx_custom_printf ppx_driver
      ppx_fields_conv ppx_here ppx_inline_test ppx_sexp_conv ppx_tools
      ppx_variants_conv re sexplib variantslib fieldslib ];

  meta = with stdenv.lib; {
    description = "Cram-like framework for OCaml";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
