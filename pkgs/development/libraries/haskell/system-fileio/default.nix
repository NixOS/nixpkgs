{ cabal, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "system-fileio";
  version = "0.3.2.1";
  sha256 = "0a0vkbj9z5i74g6kkz3n4ffmvinavmnak0zxsx0fck18ppdgv394";
  buildDepends = [ systemFilepath text time ];
  meta = {
    homepage = "https://john-millikin.com/software/hs-fileio/";
    description = "High-level filesystem interaction";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
