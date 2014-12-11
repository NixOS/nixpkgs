{ stdenv, agda, fetchdarcs, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "2014-11-28";
  name = "TotalParserCombinators-${version}";

  src = fetchdarcs {
    url = "http://www.cse.chalmers.se/~nad/repos/parser-combinators.code/";
    context = ./contextfile;
    sha256 = "03fjrgj0749929h5zz6yfz5x9h7fln95c8ydrm44550350n4xjvk";
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
