{ cabal }:

cabal.mkDerivation (self: {
  pname = "deepseq";
  version = "1.3.0.1";
  sha256 = "068zka6rwprbzpx7yisi1ajsxdly23zaf2vjklx1wp66yypx54lp";
  meta = {
    description = "Deep evaluation of data structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
