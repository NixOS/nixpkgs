{lib, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv, typerep}:

buildOcamlJane {
  name = "ppx_typerep_conv";
  hash = "0dldlx73r07j6w0i7h4hxly0v678naa79na5rafsk2974gs5ih9g";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv typerep ];

  meta = with lib; {
    description = "Automatic generation of runtime types from type definitions";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
