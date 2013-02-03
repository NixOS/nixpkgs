{ cabal }:

cabal.mkDerivation (self: {
  pname = "cipher-rc4";
  version = "0.1.2";
  sha256 = "0nyrqms7h3hq236h03sjjjqdcxn3iz3fg4ifqj43f4nb8gv0ifb1";
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-rc4";
    description = "Fast RC4 cipher implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
