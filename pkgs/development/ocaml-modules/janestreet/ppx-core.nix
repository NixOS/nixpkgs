{stdenv, buildOcamlJane, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_core";
  hash = "0df7vyai488lfkyh8szw2hvn22jsyrkfvq1b91j1s0g0y27nnfax";
  propagatedBuildInputs =
    [ ppx_tools ];

  meta = with stdenv.lib; {
    description = "PPX standard library";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
