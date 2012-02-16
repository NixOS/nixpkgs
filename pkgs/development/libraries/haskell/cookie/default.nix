{ cabal, blazeBuilder, Cabal, dataDefault, text, time }:

cabal.mkDerivation (self: {
  pname = "cookie";
  version = "0.4.0";
  sha256 = "1vkz6nys26i0yprb8jkv8iyq9xqnxb0wv07f7s7c448vx4gfln98";
  buildDepends = [ blazeBuilder Cabal dataDefault text time ];
  meta = {
    homepage = "http://github.com/snoyberg/cookie";
    description = "HTTP cookie parsing and rendering";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
