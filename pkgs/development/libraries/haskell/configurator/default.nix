{ cabal, attoparsec, hashable, text, unixCompat
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "configurator";
  version = "0.2.0.2";
  sha256 = "011rgd48gv4idkh2dwg4mlyx3s6pgm1263xq5ixsa4sg3jqh9d8b";
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
