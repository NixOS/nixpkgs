{ stdenv, agda, fetchdarcs, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "2015-03-19";
  name = "pretty-${version}";

  src = fetchdarcs {
    url = "http://www.cse.chalmers.se/~nad/repos/pretty/";
    context = ./contextfile;
    sha256 = "0zmwh9kln7ykpmkx1qhqz64qm2arq62b17vs5fswnxk7mqxsmrf0";
  };

  buildDepends = [ AgdaStdlib ];
  everythingFile = "Pretty.agda";
  sourceDirectories = [];
  topSourceDirectories = [ "../$sourceRoot" ];

  meta = with stdenv.lib; {
    homepage = http://www.cse.chalmers.se/~nad/publications/danielsson-correct-pretty.html;
    description = "Correct-by-Construction Pretty-Printing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ fuuzetsu ];
  };
})
