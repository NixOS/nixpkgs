{ cabal }:

cabal.mkDerivation (self: {
  pname = "polyparse";
  version = "1.4";
  sha256 = "6e599fb0771e8ce2e1d3a3bbe5eddc2d77b2b4bbb54602f01005dc55dc039d44";
  meta = {
    homepage = "http://www.cs.york.ac.uk/fp/polyparse/";
    description = "A variety of alternative parser combinator libraries";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
