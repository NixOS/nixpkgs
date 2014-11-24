{ stdenv, agda, fetchdarcs, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "2014-09-27";
  name = "pretty-${version}";

  src = fetchdarcs {
    url = "http://www.cse.chalmers.se/~nad/repos/pretty/";
    context = ./contextfile;
    sha256 = "067pv55r3wlchbgjpx3ha5hyzr29y6xsix0ywwgirm8njcc8nv16";
  };

  buildDepends = [ AgdaStdlib ];
  everythingFile = "Pretty.agda";
  sourceDirectories = [];
  topSourceDirectories = [ "../$sourceRoot" ];

  meta = with stdenv.lib; {
    homepage = "http://www.cse.chalmers.se/~nad/publications/danielsson-correct-pretty.html";
    description = "Correct-by-Construction Pretty-Printing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ fuuzetsu ];
    broken = true;
  };
})
