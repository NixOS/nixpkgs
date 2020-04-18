{stdenv, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv}:

buildOcamlJane {
  name = "ppx_fields_conv";
  hash = "11w9wfjgkv7yxv3rwlwi6m193zan6rhmi45q7n3ddi2s8ls3gra7";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv ];

  meta = with stdenv.lib; {
    description = "Generation of accessor and iteration functions for ocaml records";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
