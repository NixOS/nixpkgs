{ cabal, extensibleExceptions, filepath, mtl, terminfo, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.6.4.6";
  sha256 = "136h71rb50sypkdbnk849mbcgfzx3y4hfxmx2c7kf90zpmsx5wmj";
  buildDepends = [
    extensibleExceptions filepath mtl terminfo utf8String
  ];
  configureFlags = "-fterminfo";
  patchPhase = ''
    sed -i -e "s|mtl >= 1.1 && < 2.1|mtl|" haskeline.cabal
  '';
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
