{ cabal, blazeBuilder, mtl, syb, text, utf8String }:

cabal.mkDerivation (self: {
  pname = "hastache";
  version = "0.2.4";
  sha256 = "0881sh3vp5v8kk3rnz9dg2bnis6qy4gx5sr0sqj6xl162sbhf3yv";
  buildDepends = [ blazeBuilder mtl syb text utf8String ];
  meta = {
    homepage = "http://github.com/lymar/hastache";
    description = "Haskell implementation of Mustache templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
