{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "mime";
  version = "0.4.0";
  sha256 = "159jp7dcyx26slda2743zdr2prnm707mnglcb9p66hr1wjh98kx4";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/GaloisInc/mime";
    description = "Working with MIME types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
