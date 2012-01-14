{ cabal, parsec, strict, time }:

cabal.mkDerivation (self: {
  pname = "wxdirect";
  version = "0.13.1.1";
  sha256 = "00zij92hm7rbl8sx6f625cqzwgi72c8qn1dj6d1q4zg14dszarad";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ parsec strict time ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "helper tool for building wxHaskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
