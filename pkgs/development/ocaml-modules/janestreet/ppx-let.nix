{lib, buildOcamlJane,
 ppx_core, ppx_driver}:

buildOcamlJane {
  pname = "ppx_let";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_driver ];

  meta = with lib; {
    description = "A ppx rewriter for monadic and applicative let bindings and match statements";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
