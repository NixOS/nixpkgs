{stdenv, buildOcamlJane,
 ppx_core, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_optcomp";
  hash = "09m2x2a5ics4bz1j29n5slhh1rlyhcwdfmf44v1jfxcby3f0riwd";
  propagatedBuildInputs =
    [ ppx_core ppx_tools ];

  meta = with stdenv.lib; {
    description = "ppx_optcomp stands for Optional Compilation. It is a tool used to handle optional compilations of pieces of code depending of the word size, the version of the compiler, etc.";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
