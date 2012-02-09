{ cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "json";
  version = "0.5";
  sha256 = "12jbvq0lp7z5q6g94pv8s5455yydfyh9h2xlr76wqzfh3myvy6fl";
  buildDepends = [ mtl parsec syb ];
  meta = {
    description = "Support for serialising Haskell to and from JSON";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
