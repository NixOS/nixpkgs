{ cabal, ListLike, uuParsinglib }:

cabal.mkDerivation (self: {
  pname = "NanoProlog";
  version = "0.3";
  sha256 = "0wjjwzzc78sj7nsaq1hgxiwv0pc069mxns425lhmrlxcm0vf8fmn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ ListLike uuParsinglib ];
  meta = {
    description = "Very small interpreter for a Prolog-like language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
