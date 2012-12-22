{ cabal, attoparsec, hashable, text, unixCompat
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "configurator";
  version = "0.2.0.1";
  sha256 = "02w6f5q2xkpc3kgqz6a58g7yr0q4xd8ck1b6lr64ahvqwsjbxy6p";
  buildDepends = [
    attoparsec hashable text unixCompat unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/bos/configurator";
    description = "Configuration management";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
