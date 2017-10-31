{stdenv, buildOcamlJane,
 ppx_core, ppx_driver, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_pipebang";
  hash = "0k25bhj9ziiw89xvs4svz7cgazbbmprba9wbic2llffg55fp7acc";
  propagatedBuildInputs = [ ppx_core ppx_driver ppx_tools ];

  meta = with stdenv.lib; {
    description = "A ppx rewriter that inlines reverse application operators |> and |!";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
