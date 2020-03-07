{stdenv, buildOcamlJane,
 core_kernel,
 bin_prot, fieldslib, sexplib, typerep, variantslib,
 ppx_assert, ppx_bench, ppx_driver, ppx_expect, ppx_inline_test, ppx_jane}:

buildOcamlJane {
  name = "core";
  hash = "0nz6d5glgymbpchvcpw77yis9jgi2bll32knzy9vx99wn83zdrmd";
  propagatedBuildInputs =
    [ core_kernel bin_prot fieldslib sexplib typerep variantslib
      ppx_assert ppx_bench ppx_driver ppx_expect ppx_inline_test ppx_jane ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core;
    description = "Jane Street Capital's standard library overlay";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
