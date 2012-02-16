{ cabal, Cabal, extensibleExceptions, filepath, mtl, terminfo
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.6.4.6";
  sha256 = "136h71rb50sypkdbnk849mbcgfzx3y4hfxmx2c7kf90zpmsx5wmj";
  buildDepends = [
    Cabal extensibleExceptions filepath mtl terminfo utf8String
  ];
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
