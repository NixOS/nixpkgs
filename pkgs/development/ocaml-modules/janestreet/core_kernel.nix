{stdenv, buildOcamlJane, fetchurl,
 bin_prot, fieldslib, sexplib, typerep, variantslib,
 ppx_assert, ppx_bench, ppx_driver, ppx_expect, ppx_inline_test, ppx_jane,
 ocaml_oasis, opam, js_build_tools}:

buildOcamlJane rec {
  name = "core_kernel";
  hash = "13gamj056nlib04l7yh80lqpdx0pnswzlb52fkqa01awwp5nf3z6";
  propagatedBuildInputs =
    [ bin_prot fieldslib sexplib typerep variantslib
      ppx_assert ppx_bench ppx_driver ppx_expect ppx_inline_test ppx_jane ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core_kernel;
    description = "Jane Street Capital's standard library overlay (kernel)";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
