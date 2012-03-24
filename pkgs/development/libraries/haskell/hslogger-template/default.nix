{ cabal, hslogger, mtl }:

cabal.mkDerivation (self: {
  pname = "hslogger-template";
  version = "2.0.0";
  sha256 = "1x8c132ckxjhnhlrnm92h0hkalkrgcc91cn73kv9kvcwy9b2fqcr";
  buildDepends = [ hslogger mtl ];
  meta = {
    description = "Automatic generation of hslogger functions";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
