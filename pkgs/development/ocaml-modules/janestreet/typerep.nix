{stdenv, buildOcamlJane, type_conv}:

buildOcamlJane {
  name = "typerep";
  version = "113.33.03";

  minimumSupportedOcamlVersion = "4.00";

  hash = "1ss34nq20vfgx8hwi5sswpmn3my9lvrpdy5dkng746xchwi33ar7";

  propagatedBuildInputs = [ type_conv ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/janestreet/typerep";
    description = "Runtime types for OCaml (beta version)";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };

}
