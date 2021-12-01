{lib, buildOcamlJane,
 ppx_core, ppx_driver, ppx_tools}:

buildOcamlJane {
  pname = "ppx_pipebang";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_driver ppx_tools ];

  meta = with lib; {
    description = "A ppx rewriter that inlines reverse application operators |> and |!";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
