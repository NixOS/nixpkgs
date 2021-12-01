{lib, buildOcamlJane,
 ppx_core, ppx_tools}:

buildOcamlJane {
  pname = "ppx_optcomp";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs =
    [ ppx_core ppx_tools ];

  meta = with lib; {
    description = "ppx_optcomp stands for Optional Compilation. It is a tool used to handle optional compilations of pieces of code depending of the word size, the version of the compiler, etc.";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
