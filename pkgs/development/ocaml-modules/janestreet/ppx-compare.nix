{stdenv, buildOcamlJane,
 ppx_core, ppx_driver, ppx_tools, ppx_type_conv}:

buildOcamlJane {
  name = "ppx_compare";
  hash = "05cnwxfxm8201lpfmcqkcqfy6plh5c2151jbj4qsnxhlvvjli459";
  propagatedBuildInputs =
    [ppx_core ppx_driver ppx_tools ppx_type_conv ];

  meta = with stdenv.lib; {
    description = "Generation of fast comparison functions from type expressions and definitions";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
