{stdenv, buildOcamlJane,
 ppx_core, ppx_driver, ppx_here, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_fail";
  hash = "1ms5axpc0zg469zj4799nz3wwxi6rmmyvqj52dy03crmpj71s18l";
  propagatedBuildInputs = [ ppx_core ppx_driver ppx_here ppx_tools ];

  meta = with stdenv.lib; {
    description = "Syntax extension that makes failwith include a position";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
