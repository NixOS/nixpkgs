{stdenv, buildOcamlJane,
 bin_prot, core_kernel, fieldslib, sexplib, typerep, variantslib,
 ppx_assert, ppx_bench, ppx_driver, ppx_expect, ppx_inline_test, ppx_jane,
 rsync}:

buildOcamlJane {
  name = "re2";
  hash = "0fw5jscb1i17aw8v4l965zw20kyimhfnmf4w83wqaaxkqy3l6fqw";
  buildInputs = [ rsync ];
  propagatedBuildInputs =
    [ bin_prot core_kernel fieldslib sexplib typerep variantslib
      ppx_assert ppx_bench ppx_driver ppx_expect ppx_inline_test ppx_jane ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/re2;
    description = "OCaml bindings for RE2";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
