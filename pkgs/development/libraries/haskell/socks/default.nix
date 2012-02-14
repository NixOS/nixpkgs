{ cabal, Cabal, cereal, network }:

cabal.mkDerivation (self: {
  pname = "socks";
  version = "0.4.1";
  sha256 = "0kapic4rf1cwbqy5f229b69kr1mg9blpr5p5jna8sx5ds2b8jdjn";
  buildDepends = [ Cabal cereal network ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-socks";
    description = "Socks proxy (version 5) implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
