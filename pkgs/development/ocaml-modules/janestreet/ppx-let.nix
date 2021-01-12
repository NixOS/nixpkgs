{lib, buildOcamlJane,
 ppx_core, ppx_driver}:

buildOcamlJane {
  name = "ppx_let";
  hash = "0whnfq4rgkq4apfqnvc100wlk25pmqdyvy6s21dsn3fcm9hff467";
  propagatedBuildInputs = [ ppx_core ppx_driver ];

  meta = with lib; {
    description = "A ppx rewriter for monadic and applicative let bindings and match statements";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
