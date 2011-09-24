{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "xml";
  version = "1.3.10";
  sha256 = "0mmibqzbbqmw4a8gc4f2yy144nx48gpfwj3iqq6dydvcikajxav2";
  buildDepends = [ text ];
  meta = {
    homepage = "http://code.galois.com";
    description = "A simple XML library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
