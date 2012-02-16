{ cabal }:

cabal.mkDerivation (self: {
  pname = "threadmanager";
  version = "0.1.4";
  sha256 = "0p35ihdc9k9svzbwiszll5i53km09rvw5mqshph273fby7nvni9i";
  meta = {
    homepage = "http://github.com/bsl/threadmanager";
    description = "Simple thread management";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
