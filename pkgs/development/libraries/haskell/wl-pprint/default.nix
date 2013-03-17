{ cabal }:

cabal.mkDerivation (self: {
  pname = "wl-pprint";
  version = "1.1";
  sha256 = "16kp3fkh0x9kgzk6fdqrm8m0v7b5cgbv0m3x63ybbp5vxbhand06";
  meta = {
    description = "The Wadler/Leijen Pretty Printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
