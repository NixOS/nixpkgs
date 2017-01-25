{stdenv, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv, bin_prot}:

buildOcamlJane rec {
  name = "ppx_bin_prot";
  hash = "0kwmrrrybdkmphqczsr3lg3imsxcjb8iy41syvn44s3kcjfyyzbz";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv bin_prot ];

  meta = with stdenv.lib; {
    description = "Generation of bin_prot readers and writers from types";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
