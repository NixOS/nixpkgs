{ stdenv, agda, fetchdarcs, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "2014-11-28";
  name = "pretty-${version}";

  src = fetchdarcs {
    url = "http://www.cse.chalmers.se/~nad/repos/pretty/";
    context = ./contextfile;
    sha256 = "1y896qqlfjqvpd09cp0x9nhr60ii21f5cibl0v73xl3z2d0wn0xa";
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
  };
})
