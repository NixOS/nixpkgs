{ cabal, adns, network }:

cabal.mkDerivation (self: {
  pname = "hsdns";
  version = "1.6";
  sha256 = "1vf3crkhs7z572bqdf7p2hfcqkjxvnyg0w0cf8b7kyfxzn8bj3fa";
  buildDepends = [ network ];
  extraLibraries = [ adns ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/peti/hsdns";
    description = "Asynchronous DNS Resolver";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
