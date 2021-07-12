{lib, buildOcamlJane,
 ppx_core, ppx_driver}:

buildOcamlJane {
  name = "ppx_here";
  hash = "1mzdgn8k171zkwmbizf1a48l525ny0w3363c7gknpnifcinxniiw";
  propagatedBuildInputs = [ ppx_core ppx_driver ];

  meta = with lib; {
    description = "A ppx rewriter that defines an extension node whose value is its source position";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
