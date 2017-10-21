{stdenv, buildOcamlJane,
 ppx_core, ppx_driver, ppx_here, ppx_sexp_conv, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_sexp_value";
  hash = "04602ppqfwx33ghjywam00hlqqzsz4d99r60k9q0v1mynk9pjhj0";
  propagatedBuildInputs = [ ppx_core ppx_driver ppx_here ppx_sexp_conv ppx_tools ];

  meta = with stdenv.lib; {
    description = "A ppx rewriter that simplifies building S-Expression from OCaml Values";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
