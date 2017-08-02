{ stdenv, agda, fetchdarcs, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "2015-03-19";
  name = "TotalParserCombinators-${version}";

  src = fetchdarcs {
    url = "http://www.cse.chalmers.se/~nad/repos/parser-combinators.code/";
    context = ./contextfile;
    sha256 = "0jlbz8yni6i7vb2qsd41bdkpchqirvc5pavckaf97z7p4gqi2mlj";
  };

  buildDepends = [ AgdaStdlib ];
  everythingFile = "TotalParserCombinators.agda";
  sourceDirectories = [];
  topSourceDirectories = [ "../$sourceRoot" ];

  meta = with stdenv.lib; {
    homepage = http://www.cse.chalmers.se/~nad/publications/danielsson-parser-combinators.html;
    description = "A monadic parser combinator library which guarantees termination of parsing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ fuuzetsu ];
    broken = true;
  };
})
