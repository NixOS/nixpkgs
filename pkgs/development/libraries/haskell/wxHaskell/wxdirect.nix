{ cabal, parsec, strict, time }:

cabal.mkDerivation (self: {
  pname = "wxdirect";
  version = "0.13.1.2";
  sha256 = "1gn5si6939yizlkf7hzm2a2gff5sa98m7q5q1hz23av98zfa8pv7";
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
