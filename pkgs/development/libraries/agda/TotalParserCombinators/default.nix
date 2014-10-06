{ stdenv, agda, fetchdarcs, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "2014-09-27";
  name = "TotalParserCombinators-${version}";

  src = fetchdarcs {
    url = "http://www.cse.chalmers.se/~nad/repos/parser-combinators.code/";
    context = ./contextfile;
    sha256 = "1rb8prqqp4dnz9s83ays7xfvpqs0n20vl1bg2zlg5si171j9rd4i";
  };

  buildDepends = [ AgdaStdlib ];
  everythingFile = "TotalParserCombinators.agda";
  sourceDirectories = [];
  topSourceDirectories = [ "../$sourceRoot" ];

  meta = with stdenv.lib; {
    homepage = "http://www.cse.chalmers.se/~nad/publications/danielsson-parser-combinators.html";
    description = "A monadic parser combinator library which guarantees termination of parsing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ fuuzetsu ];
  };
})
