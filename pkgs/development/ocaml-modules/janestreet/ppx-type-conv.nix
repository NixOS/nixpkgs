{stdenv, buildOcamlJane,
 ppx_core, ppx_deriving, ppx_driver, ppx_tools}:

buildOcamlJane {
  name = "ppx_type_conv";
  hash = "0gv0mqwn97dwrfm6rj442565y8dz7kiq8s8vadnhywrl7j4znqyq";
  propagatedBuildInputs =
    [ ppx_core ppx_deriving ppx_driver ppx_tools ];

  meta = with stdenv.lib; {
    description = "The type_conv library factors out functionality needed by different preprocessors that generate code from type specifications";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
