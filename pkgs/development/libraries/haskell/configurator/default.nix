{ cabal, attoparsec, hashable, text, unixCompat
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "configurator";
  version = "0.2.0.0";
  sha256 = "0zkcmziyfq2sm9i75ysi5nxd21fynp88m0safhmn3jld7plj03la";
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
