{ cabal, binary, cryptoPubkeyTypes, curl, dataenc, entropy, mtl
, random, RSA, SHA, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hoauth";
  version = "0.3.4";
  sha256 = "0a8a77smzhxmynfi0ayvsgibpw9aav2f7pi9j3dxjas14zg9qv2k";
  buildDepends = [
    binary cryptoPubkeyTypes curl dataenc entropy mtl random RSA SHA
    time utf8String
  ];
  meta = {
    description = "A Haskell implementation of OAuth 1.0a protocol.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
