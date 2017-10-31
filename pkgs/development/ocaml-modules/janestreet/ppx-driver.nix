{stdenv, buildOcamlJane,
 ppx_core, ppx_optcomp}:

buildOcamlJane rec {
  name = "ppx_driver";
  hash = "19cpfdn1n36vl5l9d6h7c61ffn0wmiipprn5by0354i5aywj8gpn";
  propagatedBuildInputs =
    [ ppx_core ppx_optcomp ];

  meta = with stdenv.lib; {
    description = "A driver is an executable created from a set of OCaml AST transformers linked together with a command line frontend";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
