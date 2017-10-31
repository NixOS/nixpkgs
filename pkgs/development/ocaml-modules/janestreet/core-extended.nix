{stdenv, buildOcamlJane, fetchurl,
 core,
 bin_prot, fieldslib, sexplib, typerep, variantslib,
 ppx_assert, ppx_bench, ppx_driver, ppx_expect, ppx_inline_test, ppx_jane,
 re2, textutils,
 ocaml_oasis, opam, js_build_tools}:

buildOcamlJane rec {
  name = "core_extended";
  hash = "1j4ipcn741j8w3h4gpv5sygjzg6b5g6gc2jcrr4n0jyn5dq8b0p5";
  propagatedBuildInputs =
    [ core bin_prot fieldslib sexplib typerep variantslib
      ppx_assert ppx_bench ppx_driver ppx_expect ppx_inline_test ppx_jane
      re2 textutils ];

  patchPhase = stdenv.lib.optionalString stdenv.isLinux ''
    patch src/extended_unix_stubs.c <<EOF
0a1
> #define _LINUX_QUOTA_VERSION 2
EOF
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core_extended;
    description = "Jane Street Capital's standard library overlay";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
