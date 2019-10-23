{stdenv, buildOcamlJane,
 bin_prot, core, fieldslib, sexplib, typerep, variantslib,
 ppx_assert, ppx_bench, ppx_driver, ppx_expect, ppx_inline_test, ppx_jane}:

buildOcamlJane {
  name = "textutils";
  hash = "0mkjm9b3k7db7zzrq4403v8qbkgqgkjlz120vcbqh6z7d7ql65vb";
  propagatedBuildInputs =
    [ bin_prot core fieldslib sexplib typerep variantslib
      ppx_assert ppx_bench ppx_driver ppx_expect ppx_inline_test ppx_jane ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/textutils;
    description = "Text output utilities";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
