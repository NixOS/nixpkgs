{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.5.0.4";
  sha256 = "0diaj1pmfmhwbyjmw49kna59f7dckwrp16cbar5xpcn9k2pf19nv";
  buildDepends = [ mtl text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
