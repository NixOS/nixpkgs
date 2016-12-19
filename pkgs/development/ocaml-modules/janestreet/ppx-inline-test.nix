{stdenv, buildOcamlJane,
 ppx_core, ppx_driver, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_inline_test";
  hash = "0ygapa54i0wwcj3jcqwiimrc6z0b7aafgjhbk37h6vvclnm5n7f6";
  propagatedBuildInputs = [ ppx_core ppx_driver ppx_tools ];

  meta = with stdenv.lib; {
    description = "Syntax extension for writing in-line tests in ocaml code";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
