{ cabal, terminalProgressBar, time }:

cabal.mkDerivation (self: {
  pname = "bytestring-progress";
  version = "1.0.3";
  sha256 = "1v9cl7d4fcchbdrpbgjj4ilg79cj241vzijiifdsgkq30ikv2yxs";
  buildDepends = [ terminalProgressBar time ];
  meta = {
    homepage = "http://github.com/acw/bytestring-progress";
    description = "A library for tracking the consumption of a lazy ByteString";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
